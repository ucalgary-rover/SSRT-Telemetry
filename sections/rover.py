import time

import streamlit as st

from src.mqtt_subscriber import MQTTSubscriber
from src.utils.read_env import read_env_variable
from src.utils.shared import *
from utils.read_env import read_env_variable

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))


@st.cache_resource
def init():
    # define globals that must be available across all files

    # initialize and return the MQTT subscriber
    return MQTTSubscriber()


@st.fragment(run_every=REFRESH_DELAY)
def update_telemetry():
    init()

    if "imu_data" not in st.session_state:
        st.session_state.imu_data = {
            "speed": 10,
            "heading": 0.0,
            "pitch": 0.0,
            "roll": 0.0,
            "battery_temp": 0.0,
            "power": 0.0,
        }
        # Pee wee: This is a bit hacky but it allows us to test the UI without needing to run the MQTT server
        # I commented "pee" because I got stuck, and this is what it gave me, lol

    st.markdown(
        f"""
        <style>
        :root {{
            --pitch-deg: {st.session_state.imu_data['pitch']}deg;
            --roll-deg: {st.session_state.imu_data['roll']}deg;
        }}

        [data-testid="battery-temp-text"] p, [data-testid="power-text"] p {{
            text-align: center;
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 0px;

            display: flex;
            justify-content: center;
            width: 100%;
        }}

        [data-testid="battery-temp"] p, [data-testid="power"] p {{
            text-align: center;
            font-size: 2.5rem;
            font-weight: bold;

            display: flex;
            justify-content: center;
            width: 100%;
        }}

        </style>
    """,
        unsafe_allow_html=True,
    )

    pitch_col, roll_col, wheels_col, arm_col, power_col = st.columns(
        5, vertical_alignment="top"
    )

    with pitch_col:
        with st.container(key="rover-pitch"):
            st.image("assets/rover-side-view.png", width="stretch")
        with st.container(key="rover-pitch-text"):
            st.markdown("Pitch: %0.2f°" % st.session_state.imu_data["pitch"])

    with roll_col:
        with st.container(key="rover-roll"):
            st.image("assets/rover-front-view.png", width="stretch")
        with st.container(key="rover-roll-text"):
            st.markdown("Roll: %0.2f°" % st.session_state.imu_data["roll"])

    with wheels_col:
        with st.container(key="rover-wheels"):
            st.image("assets/rover-wheels.png", width="stretch")
        with st.container(key="rover-wheels-text"):
            st.markdown("Wheels")

    with arm_col:
        with st.container(key="rover-arm"):
            st.image("assets/rover-arm.png", width="stretch")
        with st.container(key="rover-arm-text"):
            st.markdown("Arm")

    with power_col:
        st.metric(
            label="Battery Temp",
            value="%0.2f°C" % st.session_state.imu_data["battery_temp"],
        )
        st.metric(label="Power", value="%0.2f%%" % st.session_state.imu_data["power"])

        # with st.container(key="battery-temp-text"):
        #     st.markdown("Battery Temperature")
        # with st.container(key="battery-temp"):
        #     st.markdown("%0.2f°C" % st.session_state.imu_data["battery_temp"])
        # with st.container(key="power-text"):
        #     st.markdown("Power")
        # with st.container(key="power"):
        #    st.markdown("%0.2f%%" % st.session_state.imu_data["power"])

        # wait for new message from MQTT server
        while not imu_queue.empty():
            published_string = imu_queue.get_nowait()
            separate_data = published_string.split(", ")
            important_keys = [
                "pitch",
                "roll",
                "battery_temp",
                "power",
            ]  # Speed and Heading are not in the IMU

            for i in range(len(separate_data)):
                if separate_data[i].split(":")[0].lower() in important_keys:
                    data_as_float = separate_data[i].split(" ")
                    key = separate_data[i].split(":")[0].lower()

                    st.session_state.imu_data[key] = float(data_as_float[-1])

                # Special case for battery temp since it has a space in the key name
                if separate_data[i].split(":")[0].lower() == "battery temp":
                    data_as_float = separate_data[i].split(" ")
                    key = "battery_temp"

                    st.session_state.imu_data[key] = float(data_as_float[-1])

        # wait before checking for a new update
        time.sleep(REFRESH_DELAY)


def display():
    temp = st.empty()

    with temp.container():
        update_telemetry()
