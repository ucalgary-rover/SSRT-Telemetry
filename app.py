import time

import streamlit as st

from src import settings
from src.mqtt_subscriber import MQTTSubscriber


@st.cache_resource
def init():
    # initialize any setting values
    settings.init()

    # initialize and return the MQTT subscriber
    return MQTTSubscriber()


def main():
    mqtt_subscriber = init()

    st.title("Live Temperature Monitor")

    if "latest_temp" not in st.session_state:
        st.session_state.latest_temp = "Waiting..."

    # Display
    slot = st.empty()
    slot.metric("Temperature", st.session_state.latest_temp)

    while True:
        updated = False

        # wait for new message from MQTT server
        while not settings.message_queue.empty():
            st.session_state.latest_temp = settings.message_queue.get_nowait()
            updated = True

        if updated:
            slot.metric("Temperature", st.session_state.latest_temp)

        # wait before checking for a new update
        time.sleep(settings.refresh_delay)


if __name__ == "__main__":
    main()
