import streamlit as st

from src.utils.read_env import read_env_variable

VIDEO_URL = f"http://{read_env_variable('ROVER_IP')}:{read_env_variable('CAMERA_FEED_PORT')}/video_feed/"


def camera_view(cam_id: int):
    k = f"rot_{cam_id}"
    if k not in st.session_state:
        st.session_state[k] = 0

    rotate = False
    _, col_c, _ = st.columns([1, 1, 1])
    with col_c:
        rotate = st.button("Rotate", key=f"btn_{cam_id}")

    if rotate:
        st.session_state[k] = (st.session_state[k] + 90) % 360

    deg = st.session_state[k]

    with st.container():
        st.html(
            f"""
          <div id="cam_{cam_id}"
               style="width:100%; max-width:900px;
                      aspect-ratio:16/9; overflow:hidden; position:relative;">
            <img src="{VIDEO_URL}{cam_id}"
                 style="width:100%; height:100%; object-fit:contain;
                        transform:rotate({deg}deg);
                        transform-origin:center center;" />
          </div>
        """
        )


st.title("Camera Feed Test Page")
col1, col2 = st.columns(2)

with col1:
    camera_view(0)

with col2:
    camera_view(2)
