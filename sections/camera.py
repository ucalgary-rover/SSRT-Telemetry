import os
import time
from datetime import datetime
from threading import Thread

import cv2
import numpy as np
import requests
import streamlit as st

from components.shared_components import horizontal_divider
from utils.camera_utils import get_available_cameras
from utils.read_env import read_env_variable

BASE_URL = (
    f"http://{read_env_variable('ROVER_IP')}:{read_env_variable('CAMERA_FEED_PORT')}"
)
VIDEO_URL = f"{BASE_URL}/video_feed/"


def camera_preview_html(cam_id: int, deg: int) -> str:
    return f"""
        <div style="
            width:100%;
            aspect-ratio:16/9;
            overflow:hidden;
            position:relative;">
            <img src="{VIDEO_URL}{cam_id}"
                style="position:absolute;
                    top:50%;
                    left:50%;
                    width:100%;
                    height:100%;
                    transform:translate(-50%, -50%) rotate({deg}deg);
                    transform-origin:center center;"/>
        </div>"""


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


def display():
    # Shows recording status after record button is clicked
    if "rec_status" in st.session_state:
        st.toast(st.session_state.pop("rec_status"))

    cameras = get_available_cameras()
    with st.container(key="camera-container"):
        dropdown_select, rotate_col, screenshot_col, record_col, popout = st.columns(
            [0.3, 0.1, 0.1, 0.1, 0.08]
        )
        with dropdown_select:
            if not cameras:
                selected_camera = st.selectbox(
                    "Camera",
                    index=0,
                    options=["No cameras detected"],
                    label_visibility="collapsed",
                    disabled=True,
                )
            else:
                selected_camera = st.selectbox(
                    "Camera",
                    options=cameras,
                    format_func=lambda x: f"Camera {x}",
                    label_visibility="collapsed",
                    key="telemetry_camera_select",
                )
        with rotate_col:
            if cameras:
                rot_key = f"preview_rot_{selected_camera}"
                if rot_key not in st.session_state:
                    st.session_state[rot_key] = 0
                if st.button("Rotate", key="preview_rotate"):
                    st.session_state[rot_key] = (st.session_state[rot_key] + 90) % 360

        recording_state = get_recording_state()

        with screenshot_col:
            if cameras:
                if st.button("Screenshot", key="preview_screenshot"):
                    take_screenshot(selected_camera)

        with record_col:
            if cameras:
                is_recording = recording_state["flags"].get(selected_camera, False)
                label = "Stop" if is_recording else "Record"
                if st.button(label, key="preview_record", type="primary"):
                    if is_recording:
                        stop_record(selected_camera, recording_state)
                        st.session_state[
                            "rec_status"
                        ] = f"stopped recording camera {selected_camera}"
                    else:
                        start_record(selected_camera, recording_state)
                        st.session_state[
                            "rec_status"
                        ] = f"recording on camera {selected_camera}"
                    st.rerun()  # renders changed button label

        with popout:
            if st.button("↗", width="stretch"):
                st.switch_page("pages/Camera_Page.py")

        horizontal_divider()
        if not cameras:
            st.markdown(
                """
                <div style="
                    width:100%;
                    aspect-ratio:16/9;
                    display:flex;
                    align-items:center;
                    justify-content:center;
                ">
                    No cameras detected
                </div>
                """,
                unsafe_allow_html=True,
            )
        else:
            with st.container(key="camera-preview"):
                rot_key = f"preview_rot_{selected_camera}"
                if rot_key not in st.session_state:
                    st.session_state[rot_key] = 0
                st.html(
                    camera_preview_html(
                        selected_camera,
                        st.session_state[rot_key],
                    )
                )