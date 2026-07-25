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


def display():
    cameras = get_available_cameras()
    with st.container(key="camera-container"):
        dropdown_select, rotate_col, popout = st.columns([0.4, 0.1, 0.1])
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
