from logging_config import setup_logging

setup_logging()

import streamlit as st
from mqtt.subscriber import MQTTSubscriber
from utils.read_env import read_env_variable
from state.read_latest_from_queue import latest_values

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))
SAMPLE_TOPIC = read_env_variable("SAMPLE_TOPIC")
SAMPLE_TOPIC2 = read_env_variable("SAMPLE_TOPIC2")


@st.cache_resource
def init_mqtt():
    return MQTTSubscriber()


@st.fragment(run_every=REFRESH_DELAY)
def temperature_section():
    value, updated = latest_values[SAMPLE_TOPIC].get_if_updated()
    if updated:
        st.session_state.latest_temp = value
    st.metric("Temperature", st.session_state.get("latest_temp", "Waiting..."))


@st.fragment(run_every=REFRESH_DELAY)
def temperature_section2():
    value, updated = latest_values[SAMPLE_TOPIC2].get_if_updated()
    if updated:
        st.session_state.latest_temp2 = value
    st.metric("Temperature 2", st.session_state.get("latest_temp2", "Waiting..."))


def main():
    st.set_page_config(
        page_title="SSRT Telemetry", layout="wide", initial_sidebar_state="collapsed"
    )

    init_mqtt()

    st.title("Live Temperature Monitor")

    if "latest_temp" not in st.session_state:
        st.session_state.latest_temp = "Waiting..."
        st.session_state.latest_temp2 = "Waiting..."

    temperature_section()
    temperature_section2()


if __name__ == "__main__":
    main()
