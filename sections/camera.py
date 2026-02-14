import streamlit as st

from src.utils.components import horizontal_divider

# placeholder images for now
CAMERA_FEEDS = {
    "Camera 1": "assets/cameras/placeholder-1.jpg",
    "Camera 2": "assets/cameras/placeholder-2.jpg",
    "Camera 3": "assets/cameras/placeholder-3.jpg",
}


def display():
    with st.container(key="camera-container"):
        dropdown_select, blank, popout = st.columns([0.4, 0.2, 0.1])

        # dropdown menu, does not show label 'camera'
        with dropdown_select:
            # st.text("Camera dropdown select")
            selected_camera = st.selectbox(
                "Camera",
                options=list(CAMERA_FEEDS.keys()),
                label_visibility="collapsed",
                key="telemetry_camera_select",
            )

        with popout:
            if st.button("↗", width="stretch"):
                st.switch_page("pages/Camera_Page.py")
            # st.text("Popout")

        horizontal_divider()
        st.image(CAMERA_FEEDS[selected_camera], width="stretch")
        # box changes size depending on image, maybe fix w/ css aspect ratio?

        # st.text("Camera Display")
