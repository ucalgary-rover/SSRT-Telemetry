import os
import time
from datetime import datetime
from threading import Thread

import cv2
import numpy as np
import requests
import streamlit as st


BASE_URL = "http://localhost:8995"
VIDEO_URL = f"{BASE_URL}/video_feed/"


def camera_html(cam_id: int, deg: int) -> str:
    return f"""
      <div id="cam_{cam_id}" style="width:100%; max-width:900px;
            aspect-ratio:16/9; overflow:hidden; position:relative;">
        <img src="{VIDEO_URL}{cam_id}"
             style="width:100%; height:100%; object-fit:contain;
                    transform:rotate({deg}deg);
                    transform-origin:center center;" />
      </div>
    """


def camera_view(cam_id: int):
    k = f"rot_{cam_id}"
    if k not in st.session_state:
        st.session_state[k] = 0

    rotate = False
    with st.container(horizontal_alignment="center"):
        rotate = st.button("Rotate", key=f"btn_{cam_id}")

    if rotate:
        st.session_state[k] = (st.session_state[k] + 90) % 360

    deg = st.session_state[k]

    st.write(f"Camera {cam_id}")

    with st.container():
        st.html(camera_html(cam_id, deg))

        col_left, col_right = st.columns(2)

        with col_left:
            if st.button(
                "Screenshot",
                key=f"screenshot_{cam_id}",
                type="secondary",
                width="stretch",
            ):
                take_screenshot(cam_id)

        recording_state = get_recording_state()

        with col_right:
            is_recording = recording_state["flags"].get(cam_id, False)
            label = "Stop Recording" if is_recording else "Record"
            if st.button(label, key=f"record_{cam_id}", type="primary", width="stretch"):
                if is_recording:
                    stop_record(cam_id, recording_state)
                    st.session_state["rec_status"] = f"stopped recording camera {cam_id}"  # store record status, to access after rerun
                else:
                    start_record(cam_id, recording_state)
                    st.session_state["rec_status"] = f"recording on camera {cam_id}"
                st.rerun()  # renders changed button label


def take_screenshot(cam_id: int):
    """
    Prototype implementation:
    Pulls a single frame from the MJPEG stream and saves it
    locally on the machine running Streamlit.

    TODO: Replace with rover-side snapshot endpoint for production.
    """

    url = f"{VIDEO_URL}{cam_id}"

    try:
        response = requests.get(url, stream=True, timeout=3)

        bytes_data = b""
        jpg = None

        for chunk in response.iter_content(chunk_size=4096):
            bytes_data += chunk

            # JPEG start and end markers
            start = bytes_data.find(b"\xff\xd8")
            end = bytes_data.find(b"\xff\xd9")

            if start != -1 and end != -1 and end > start:
                jpg = bytes_data[start : end + 2]
                break

            # Prevent excessive memory growth
            if len(bytes_data) > 500000:
                bytes_data = bytes_data[-200000:]

        response.close()

        if jpg is None:
            st.toast(f"Camera {cam_id}: Failed to capture frame")
            return

        # Create screenshots folder locally
        os.makedirs("screenshots", exist_ok=True)

        timestamp = time.strftime("%Y%m%d_%H%M%S")
        filename = f"screenshots/cam_{cam_id}_{timestamp}.jpg"

        with open(filename, "wb") as f:
            f.write(jpg)

        st.toast(f"Camera {cam_id}: Screenshot saved")

    except requests.exceptions.RequestException:
        st.toast(f"Camera {cam_id}: Unable to connect to stream")
    except Exception as e:
        st.toast(f"Camera {cam_id}: Screenshot failed")


@st.cache_resource
def get_recording_state():
    """
    Used to track recording status on each camera and stores thread references per
    camera without being reset on every rerun.
    """
    return {"flags": {}, "threads": {}}


def start_record(cam_id: int, recording_state: dict):
    """
    Sets the recording status for the given camera to True and launches a background
    thread that pulls frames from the MJPEG stream.
    """
    recording_state["flags"][cam_id] = True
    t = Thread(target=video_capture, args=(cam_id, recording_state), daemon=True)
    recording_state["threads"][cam_id] = t
    t.start()


def stop_record(cam_id: int, recording_state: dict):
    """
    Sets the recording flag for the given camera to False, signalling the background
    thread to stop and waits for the thread to finish.
    """
    recording_state["flags"][cam_id] = False
    t = recording_state["threads"].get(cam_id)
    if t:
        t.join()


def video_capture(cam_id: int, recording_state: dict):
    """
    Background thread function that connects to the MJPEG stream, extracts complete
    JPEG frames, and writes them to an AVI file until the recording flag is set to False.
    """
    url = f"{VIDEO_URL}{cam_id}"
    os.makedirs("recordings", exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"recordings/cam_{cam_id}_{timestamp}.avi"
    video_writer = None

    try:
        stream = requests.get(url, stream=True, timeout=3)
        buffer = b""

        for chunk in stream.iter_content(chunk_size=4096):
            # stop recording when flag is set to False by stop_record()
            if not recording_state["flags"].get(cam_id, False):
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
                    filename, cv2.VideoWriter_fourcc(*"XVID"), 15, (w, h)
                )

            video_writer.write(frame)

        stream.close()

    finally:
        if video_writer:
            video_writer.release()


def get_available_cameras():
    try:
        resp = requests.get(f"{BASE_URL}/available_cameras", timeout=3)
        return resp.json()["cameras"]
    except Exception as e:
        print(f"Could not reach camera server: {e}")
        return []


def main():
    st.set_page_config(
        page_title="SSRT Camera Feed", layout="wide", initial_sidebar_state="collapsed"
    )

    st.title("Camera Feed Test Page")

    # Shows recording status after record button is clicked
    if "rec_status" in st.session_state:
        st.toast(st.session_state.pop("rec_status"))

    if "available_cameras" not in st.session_state:
        st.session_state["available_cameras"] = get_available_cameras()
        if len(st.session_state["available_cameras"]) > 0:
            st.toast(f"available cameras: {st.session_state['available_cameras']}")
        else:
            st.toast(f"no cameras detcted")
            st.error("No cameras available")

    cameras = st.session_state["available_cameras"]

    COLS = 3
    for i in range(len(cameras)):
        if i % COLS == 0:
            new_row = st.columns(COLS, border=True)

        with new_row[i % COLS]:
            camera_view(cameras[i])


if __name__ == "__main__":
    main()
