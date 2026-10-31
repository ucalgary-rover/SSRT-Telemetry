from pathlib import Path

from dotenv import load_dotenv

load_dotenv(Path(__file__).parent / "configs.env")

import asyncio
import logging
import os
import time
from contextlib import asynccontextmanager
from datetime import datetime
from threading import Thread

import cv2
import numpy as np
import requests
from fastapi import FastAPI, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware

import mqtt.subscriber as mqtt_subscriber
from mqtt.subscriber import MQTTSubscriber
from mqtt.topics import TOPIC_HANDLERS
from state.read_latest_from_queue import ReadLatestFromQueue, latest_values
from utils.camera_utils import get_available_cameras
from utils.read_env import read_env_variable

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("api")

BASE_URL = (
    f"http://{read_env_variable('ROVER_IP')}:{read_env_variable('CAMERA_FEED_PORT')}"
)
VIDEO_URL = f"{BASE_URL}/video_feed/"
REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))

ROLES = {
    "imu": read_env_variable("IMU_TOPIC"),
    "gnss": read_env_variable("GNSS_TOPIC"),
    "motor": read_env_variable("MOTOR_STATE_TOPIC"),
}

clients: set[WebSocket] = set()
last: dict = {}  # last known value per role, sent to new tabs right away
recording = {"flags": {}, "threads": {}}


# ---------- MQTT glue (keeps the mqtt and state folders untouched) ----------

# latest_values is built from get_all_topics(), which didn't include every topic
# the subscriber handles. TOPIC_HANDLERS is what the subscriber actually
# subscribes to, so any topic missing from latest_values gets a real holder.
for topic in TOPIC_HANDLERS:
    if topic not in latest_values:
        logger.warning("latest_values had no entry for %s, adding one", topic)
        latest_values[topic] = ReadLatestFromQueue()

# keep one bad message from killing paho's network thread
_original_on_message = mqtt_subscriber.on_message


def _safe_on_message(client, userdata, message):
    try:
        _original_on_message(client, userdata, message)
    except Exception:
        logger.exception("Error handling message on %s", message.topic)


mqtt_subscriber.on_message = _safe_on_message


# ---------- telemetry ----------


async def broadcast_loop():
    while True:
        changed = {}
        for role, topic in ROLES.items():
            value, updated = latest_values[topic].get_if_updated()
            if updated:
                changed[role] = value
                last[role] = value

        if changed:
            for ws in list(clients):
                try:
                    await ws.send_json(changed)
                except Exception:
                    clients.discard(ws)

        await asyncio.sleep(REFRESH_DELAY)


@asynccontextmanager
async def lifespan(app: FastAPI):
    subscriber = MQTTSubscriber()
    task = asyncio.create_task(broadcast_loop())
    yield
    task.cancel()
    subscriber.stop()


app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.websocket("/ws/telemetry")
async def telemetry(ws: WebSocket):
    await ws.accept()
    clients.add(ws)
    if last:
        await ws.send_json(last)
    try:
        while True:
            await ws.receive_text()  # keeps the socket open, the browser never sends anything
    except WebSocketDisconnect:
        pass
    finally:
        clients.discard(ws)


# ---------- cameras ----------


@app.get("/cameras")
def cameras():
    return {"cameras": get_available_cameras()}


@app.get("/recording")
def recording_status():
    return {"flags": recording["flags"]}


@app.post("/cameras/{cam_id}/screenshot")
def screenshot(cam_id: int):
    try:
        response = requests.get(f"{VIDEO_URL}{cam_id}", stream=True, timeout=3)
    except requests.exceptions.RequestException:
        raise HTTPException(502, "Unable to connect to stream")

    buf, jpg = b"", None
    for chunk in response.iter_content(chunk_size=4096):
        buf += chunk
        start, end = buf.find(b"\xff\xd8"), buf.find(b"\xff\xd9")
        if start != -1 and end > start:
            jpg = buf[start : end + 2]
            break
        if len(buf) > 500000:
            buf = buf[-200000:]
    response.close()

    if jpg is None:
        raise HTTPException(500, "Failed to capture frame")

    os.makedirs("screenshots", exist_ok=True)
    name = f"screenshots/cam_{cam_id}_{time.strftime('%Y%m%d_%H%M%S')}.jpg"
    with open(name, "wb") as f:
        f.write(jpg)
    return {"file": name}


@app.post("/cameras/{cam_id}/record/start")
def start_record(cam_id: int):
    if recording["flags"].get(cam_id):
        return {"recording": True}
    recording["flags"][cam_id] = True
    t = Thread(target=video_capture, args=(cam_id,), daemon=True)
    recording["threads"][cam_id] = t
    t.start()
    return {"recording": True}


@app.post("/cameras/{cam_id}/record/stop")
def stop_record(cam_id: int):
    recording["flags"][cam_id] = False
    t = recording["threads"].get(cam_id)
    if t:
        t.join()
    return {"recording": False}


def video_capture(cam_id: int):
    url = f"{VIDEO_URL}{cam_id}"
    os.makedirs("recordings", exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"recordings/cam_{cam_id}_{timestamp}.avi"
    video_writer = None

    try:
        stream = requests.get(url, stream=True, timeout=3)
        buffer = b""

        for chunk in stream.iter_content(chunk_size=4096):
            # stop when stop_record() flips the flag to False
            if not recording["flags"].get(cam_id, False):
                break

            buffer += chunk

            frame_start = buffer.find(b"\xff\xd8")
            frame_end = buffer.find(b"\xff\xd9")
            if frame_start == -1 or frame_end == -1 or frame_end <= frame_start:
                continue

            jpg = buffer[frame_start : frame_end + 2]
            buffer = buffer[frame_end + 2 :]

            frame = cv2.imdecode(np.frombuffer(jpg, dtype=np.uint8), cv2.IMREAD_COLOR)
            if frame is None:
                continue

            if video_writer is None:
                h, w = frame.shape[:2]
                video_writer = cv2.VideoWriter(
                    filename, cv2.VideoWriter_fourcc(*"XVID"), 15, (w, h)  # type: ignore
                )

            video_writer.write(frame)

        stream.close()

    finally:
        if video_writer:
            video_writer.release()
        # if the stream failed to connect, don't leave the UI stuck on "Stop"
        recording["flags"][cam_id] = False