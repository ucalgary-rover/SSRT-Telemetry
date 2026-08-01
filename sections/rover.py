import streamlit as st
import base64
import streamlit.components.v1 as components

from state.read_latest_from_queue import latest_values
from utils.read_env import read_env_variable

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))
IMU_TOPIC = read_env_variable("IMU_TOPIC")
MOTOR_STATE_TOPIC = read_env_variable("MOTOR_STATE_TOPIC")


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

    motor_data, motor_updated = latest_values[MOTOR_STATE_TOPIC].get_if_updated()
    if motor_updated:
        st.session_state.motor_data = motor_data

    if "motor_data" not in st.session_state:
        st.session_state.motor_data = {
            "drive_motor_state": {"steer": [0, 0, 0, 0], "drive": [0, 0, 0, 0]},
            "arm_motor_state": {"motor_values": [0] * 7},
        }

    pitch_col, roll_col, wheels_col, arm_col, power_col = st.columns(
        5, vertical_alignment="center"
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

    with open("assets/rover-wheel.png", "rb") as f:
        wheel_b64 = base64.b64encode(f.read()).decode()

    # live drive state from MQTT — rover order: [FR, FL, BR, BL]
    drive = st.session_state.motor_data["drive_motor_state"]
    steer = drive["steer"]
    speed = drive["drive"]

    # remap rover order (0=FR 1=FL 2=BR 3=BL) -> grid (tl, tr, bl, br)
    tl, tr, bl, br = steer[1], steer[0], steer[3], steer[2]
    v_tl, v_tr, v_bl, v_br = speed[1], speed[0], speed[3], speed[2]

    def norm_angle(a):
        a = a % 360
        return a - 360 if a > 180 else a  # 350 -> -10 for display

    def velocity_to_length(v):
        return min(abs(v), 1.0) * 50  # percent; drive is normalized -1..1

    def wheel_html(rotation, velocity, wheel_b64):
        length = velocity_to_length(velocity)

        if velocity >= 0:
            arrow = f"""
            <div class="arrow arrow-up" style="height:{length}%;">
                <div class="arrow-head-up"></div>
            </div>
            """
        else:
            arrow = f"""
            <div class="arrow arrow-down" style="height:{length}%;">
                <div class="arrow-head-down"></div>
            </div>
            """

        return f"""
        <div class="wheel-wrapper">
            <img style="transform: rotate({rotation}deg);"
                src="data:image/png;base64,{wheel_b64}">
            {arrow}
        </div>
        <div class="wheel-readout">{velocity:.2f} · {norm_angle(rotation):.0f}°</div>
        """

    tl_html = wheel_html(tl, v_tl, wheel_b64)
    tr_html = wheel_html(tr, v_tr, wheel_b64)
    bl_html = wheel_html(bl, v_bl, wheel_b64)
    br_html = wheel_html(br, v_br, wheel_b64)

    html = f"""
    <style>
    .wheel-wrapper {{
        position: relative;
        width: 80%;
        aspect-ratio: 1;
    }}

    .wheel-wrapper img {{
        width: 100%;
        height: 100%;
        object-fit: contain;
    }}

    .wheel-readout {{
        margin-top: 4px;
        font-size: 0.8rem;
        font-weight: bold;
        text-align: center;
        white-space: nowrap;
        color: red;
    }}

    .arrow {{
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
        background: red;
        width: 3px;
    }}

    .arrow-up {{ bottom: 50%; }}
    .arrow-down {{ top: 50%; }}

    .arrow-head-up {{
        position: absolute;
        top: -6px;
        left: 50%;
        transform: translateX(-50%);
        border-left: 5px solid transparent;
        border-right: 5px solid transparent;
        border-bottom: 8px solid red;
    }}

    .arrow-head-down {{
        position: absolute;
        bottom: -6px;
        left: 50%;
        transform: translateX(-50%);
        border-left: 5px solid transparent;
        border-right: 5px solid transparent;
        border-top: 8px solid red;
    }}

    .wheel-container {{
        width: 100%;
        max-width: 220px;
        aspect-ratio: 1;
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, 1fr);
        gap: 12px;                 /* Add spacing between wheels */
        margin: 0 auto;
        box-sizing: border-box;
    }}

    .wheel-cell {{
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }}
    </style>

    <div class="wheel-container">

        <div class="wheel-cell">{tl_html}</div>
        <div class="wheel-cell">{tr_html}</div>
        <div class="wheel-cell">{bl_html}</div>
        <div class="wheel-cell">{br_html}</div>

    </div>
    """

    with wheels_col:
        components.html(html, height=260, scrolling=False)

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


def display():
    temp = st.empty()

    with temp.container():
        update_telemetry()