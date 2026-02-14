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

    st.write(f"Camera {cam_id}")

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

        col_left, col_right = st.columns(2)

        with col_left:
            if st.button(
                "Screenshot",
                key=f"screenshot_{cam_id}",
                type="secondary",
                width="stretch",
            ):
                take_screenshot(cam_id)

        a = f"rec_{cam_id}"
        if a not in st.session_state:
            st.session_state[a] = False

        with col_right:
            if st.button(
                "Record", key=f"record_{cam_id}", type="primary", width="stretch"
            ):

                st.session_state[a] = not st.session_state[a]

                if st.session_state[a]:
                    start_record(cam_id)
                else:
                    stop_record(cam_id)


def take_screenshot(cam_id: int):
    st.toast(f"took screenshot on camera {cam_id}")


def start_record(cam_id: int):
    st.toast(f"recording on camera {cam_id}")


def stop_record(cam_id: int):
    st.toast(f"stopped recording on camera {cam_id}")


def check_availability(cam_id: int):
    return True


def main():
    st.set_page_config(
        page_title="SSRT Camera Feed", layout="wide", initial_sidebar_state="collapsed"
    )

    st.title("Camera Feed Test Page")

    NUM_CAMERAS = 6
    if "available_cameras" not in st.session_state:
        st.session_state["available_cameras"] = []

    st.session_state["available_cameras"] = []

    for i in range(NUM_CAMERAS):
        if check_availability(i):
            st.session_state["available_cameras"].append(i)

    COLS = 3
    for i in range(len(st.session_state["available_cameras"])):
        if i % COLS == 0:
            new_row = st.columns(COLS, border=True)

        with new_row[i % COLS]:
            cam_id = st.session_state["available_cameras"][i]
            camera_view(cam_id)


if __name__ == "__main__":
    main()
