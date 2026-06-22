import streamlit as st

from state.read_latest_from_queue import latest_values
from utils.read_env import read_env_variable

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))
IMU_TOPIC = read_env_variable("IMU_TOPIC")
DECIMAL_PLACES = int(read_env_variable("DECIMAL_PLACES"))


@st.fragment(run_every=REFRESH_DELAY)
def update_telemetry():
    # wait for new message from MQTT server
    imu_data, updated = latest_values[IMU_TOPIC].get_if_updated()
    if updated:
        st.session_state.imu_data = imu_data

    st.markdown(
        f"""
        <style>
        :root {{
            --pitch-deg: {st.session_state.imu_data['pitch'] * -1}deg;
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

    pitch_col, roll_col, wheels_col, arm_col = st.columns(
        4, vertical_alignment="center"
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


def display():
    temp = st.empty()

    with temp.container():
        update_telemetry()
