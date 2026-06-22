import pathlib

import streamlit as st

from mqtt.subscriber import MQTTSubscriber
from sections import camera
from sections import map
from sections import rover
from utils.read_env import read_env_variable

# defining refresh delay here since it won't change at runtime
REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))


@st.cache_resource
def init_mqtt():
    return MQTTSubscriber()


def main():
    st.set_page_config(page_title="SSRT Telemetry", layout="wide")

    st.html(pathlib.Path("static/styles/streamlit_styles.css"))
    st.html(pathlib.Path("static/styles/telemetry_styles.css"))
    map_col, cam_col = st.columns(2)

    init_mqtt()
    if "imu_data" not in st.session_state:
        st.session_state.imu_data = {
            "roll": 0.0,
            "pitch": 0.0,
            "yaw": 0.0,
            "heading_deg": 0.0,
            "speed": 0.0,
        }
        # TODO: make this a better init process

    with map_col:
        map.display()

    with cam_col:
        camera.display()

    with st.container(key="rover-health"):
        rover.display()


if __name__ == "__main__":
    main()
