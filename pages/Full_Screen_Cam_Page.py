
from utils.read_env import read_env_variable
import streamlit as st

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

def main():
    st.set_page_config(page_title="Fullscreen Camera Feed", layout="wide", initial_sidebar_state="collapsed")

    with st.container(height="stretch"):
        st.html(camera_html(st.session_state["selected_cam_id_fs"]))

if __name__ == "__main__":
    main()