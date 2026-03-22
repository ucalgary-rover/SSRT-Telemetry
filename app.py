from logging_config import setup_logging

setup_logging()

import streamlit as st
from mqtt.subscriber import MQTTSubscriber
from utils.read_env import read_env_variable

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))


@st.cache_resource
def init_mqtt():
    return MQTTSubscriber()


@st.fragment(run_every=REFRESH_DELAY)
def temperature_section():
    from state.read_latest_from_queue import latest_values

    value, updated = latest_values[read_env_variable("SAMPLE_TOPIC")].get_if_updated()
    if not updated:
        return
    st.session_state.latest_temp = value
    st.metric("Temperature", st.session_state.latest_temp)


def main():
    st.set_page_config(
        page_title="SSRT Telemetry", layout="wide", initial_sidebar_state="collapsed"
    )

    init_mqtt()

    st.title("Live Temperature Monitor")

    if "latest_temp" not in st.session_state:
        st.session_state.latest_temp = "Waiting..."

    temperature_section()


if __name__ == "__main__":
    main()
