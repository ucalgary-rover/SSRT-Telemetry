import time

import streamlit as st

from src.mqtt_subscriber import MQTTSubscriber
from src.utils.read_env import read_env_variable
from src.utils.shared import *

# defining refresh delay here since it won't change at runtime
REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))


@st.cache_resource
def init():
    # define globals that must be available across all files

    # initialize and return the MQTT subscriber
    return MQTTSubscriber()


def main():
    init()

    st.set_page_config(
        page_title="SSRT Telemetry", layout="wide", initial_sidebar_state="collapsed"
    )

    st.title("Live Temperature Monitor")

    if "latest_temp" not in st.session_state:
        st.session_state.latest_temp = "Waiting..."

    # Display
    slot = st.empty()
    slot.metric("Temperature", st.session_state.latest_temp)

    while True:
        updated = False

        # wait for new message from MQTT server
        while not message_queue.empty():
            st.session_state.latest_temp = message_queue.get_nowait()
            updated = True

        if updated:
            slot.metric("Temperature", st.session_state.latest_temp)

        # wait before checking for a new update
        time.sleep(REFRESH_DELAY)


if __name__ == "__main__":
    main()
