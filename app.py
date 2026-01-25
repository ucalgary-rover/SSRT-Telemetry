import streamlit as st

from src.mqtt_subscriber import MQTTSubscriber


@st.cache_resource
def init():
    # define globals that must be available across all files

    # initialize and return the MQTT subscriber
    return MQTTSubscriber()


# Initialize MQTT subscriber
init()

st.set_page_config(page_title="SSRT Telemetry")
