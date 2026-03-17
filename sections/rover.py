import streamlit as st


def display():
    if "imu_data" not in st.session_state:
        st.session_state.imu_data = {
            "pitch": 0,
            "roll": 0,
            "battery_temp": 0,
            "power": 0,
        }

    st.markdown(
        f"""
        <style>
        :root {{
            --pitch-deg: {st.session_state.imu_data['pitch']}deg;
            --roll-deg: {st.session_state.imu_data['roll']}deg;
        }}
        </style>
    """,
        unsafe_allow_html=True,
    )

    pitch_col, roll_col, wheels_col, arm_col = st.columns(4, vertical_alignment="top")

    with pitch_col:
        with st.container(key="rover-pitch"):
            st.image("assets/rover-side-view.png", width="content")
        with st.container(key="rover-pitch-text"):
            st.markdown("Pitch: %0.2f°" % st.session_state.imu_data["pitch"])

    with roll_col:
        with st.container(key="rover-roll"):
            st.image("assets/rover-front-view.png", width="content")
        with st.container(key="rover-roll-text"):
            st.markdown("Roll: %0.2f°" % st.session_state.imu_data["roll"])

    with wheels_col:
        with st.container(key="rover-wheels"):
            st.image("assets/rover-wheels.png", width="content")
        with st.container(key="rover-wheels-text"):
            st.markdown("Wheels")

    with arm_col:
        with st.container(key="rover-arm"):
            st.image("assets/rover-arm.png", width="content")
        with st.container(key="rover-arm-text"):
            st.markdown("Arm")

    # with power_col:
    #     with st.container(key="battery-temp-text"):
    #         st.markdown("Battery Temperature")
    #     with st.container(key="battery-temp"):
    #         st.markdown("%0.2f°C" % st.session_state.imu_data["battery_temp"])
    #     with st.container(key="power-text"):
    #         st.markdown("Power")
    #     with st.container(key="power"):
    #         st.markdown("%0.2f%%" % st.session_state.imu_data["power"])
