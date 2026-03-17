import requests
import streamlit as st

from src.utils.components import horizontal_divider
from src.utils.read_env import read_env_variable

BASE_URL = (
    f"http://{read_env_variable('ROVER_IP')}:{read_env_variable('CAMERA_FEED_PORT')}"
)
VIDEO_URL = f"{BASE_URL}/video_feed/"


def get_available_cameras():
    try:
        response = requests.get(f"{BASE_URL}/available_cameras")
        response.raise_for_status()
        return response.json().get("cameras", [])
    except Exception:
        return []


def display():
    cameras = get_available_cameras()
    with st.container(key="camera-container"):
        dropdown_select, blank, popout = st.columns([0.4, 0.2, 0.1])

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
                st.image(f"{VIDEO_URL}{selected_camera}")
