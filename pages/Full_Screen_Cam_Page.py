import os
import time
from datetime import datetime
from threading import Thread

import cv2
import numpy as np
import requests
import streamlit as st

from utils.read_env import read_env_variable

BASE_URL = (
    f"http://{read_env_variable('ROVER_IP')}:{read_env_variable('CAMERA_FEED_PORT')}"
)
VIDEO_URL = f"{BASE_URL}/video_feed/"


def camera_html(cam_id: int) -> str:
    return f"""
      <div id="cam_{cam_id}" 
        style=" display:flex;
        overflow:hidden;
        position:relative;
        max-width:74%
        ;">
        
            <img src="{VIDEO_URL}{cam_id}"
                style="width:100%; 
                height:100%; 
                object-fit:cover;
                transform-origin:center center;" />
      </div>
    """


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
                    filename, cv2.VideoWriter_fourcc(*"XVID"), 15, (w, h)  # type: ignore
                )

            video_writer.write(frame)

        stream.close()

    finally:
        if video_writer:
            video_writer.release()


def main():
    st.set_page_config(page_title="Fullscreen Camera Feed", layout="wide", initial_sidebar_state="collapsed")

    cam_id = st.session_state["selected_cam_id_fs"]

    # Shows recording status after record button is clicked
    if "rec_status" in st.session_state:
        st.toast(st.session_state.pop("rec_status"))

    with st.container(height="stretch"):
        stream_col, controls_col = st.columns([3, 1])

        with stream_col:
            # size is hard-coded inside camera_html (max-width:74%) — never touch that
            st.html(camera_html(cam_id))

        with controls_col:
            if st.button(
                "Screenshot",
                key=f"screenshot_{cam_id}",
                type="secondary",
                width="stretch",
            ):
                take_screenshot(cam_id)

            recording_state = get_recording_state()
            is_recording = recording_state["flags"].get(cam_id, False)
            label = "Stop Recording" if is_recording else "Record"
            if st.button(
                label, key=f"record_{cam_id}", type="primary", width="stretch"
            ):
                if is_recording:
                    stop_record(cam_id, recording_state)
                    st.session_state[
                        "rec_status"
                    ] = f"stopped recording camera {cam_id}"  # store record status, to access after rerun
                else:
                    start_record(cam_id, recording_state)
                    st.session_state["rec_status"] = f"recording on camera {cam_id}"
                st.rerun()  # renders changed button label


if __name__ == "__main__":
    main()