import base64
import math

import streamlit as st
import streamlit.components.v1 as components

from state.read_latest_from_queue import latest_values
from utils.read_env import read_env_variable

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))
IMU_TOPIC = read_env_variable("IMU_TOPIC")
DECIMAL_PLACES = int(read_env_variable("DECIMAL_PLACES"))
MOTOR_STATE_TOPIC = read_env_variable("MOTOR_STATE_TOPIC")


# ---------------------------------------------------------------------------
# Arm visualiser configuration
#
# Link frame: x = forward (rover nose), y = left, z = up. The arm is a planar
# 3-link chain; ARM_YAW_INDEX optionally swings that plane about the vertical.
#
# Angle convention: joint 1 is measured from horizontal (0 deg = pointing
# straight forward, +90 = straight up). Joints 2 and 3 are measured *relative
# to the previous link*, so 0 deg = fully extended / colinear. If a joint
# rotates the wrong way or your zero is elsewhere, fix it with SIGNS/OFFSETS
# rather than editing the kinematics.
# ---------------------------------------------------------------------------
ARM_SEGMENT_LENGTHS = (0.42, 0.36, 0.18)  # upper arm, forearm, claw (metres)

# MotorID indices, mirrored from pub_general.h. MOTOR_ID_END == 7.
MOTOR_ID_BASE = 0
MOTOR_ID_SHOULDER = 1
MOTOR_ID_ELBOW = 2
MOTOR_ID_WRIST = 3
MOTOR_ID_CLAW_ROLL = 4
MOTOR_ID_CLAW_PITCH = 5
MOTOR_ID_CLAW_OPEN = 6
MOTOR_ID_END = 7

ARM_JOINT_INDICES = (MOTOR_ID_SHOULDER, MOTOR_ID_ELBOW, MOTOR_ID_WRIST)
ARM_JOINT_LABELS = ("Sho", "Elb", "Wri")

# motorValues are ints in controller-native units. Calibrate with:
#   scale  = (deg_at_raw_max - deg_at_raw_min) / (raw_max - raw_min)
#   offset = deg_at_raw_min - raw_min * scale
# For integer degrees, leave scale at 1.0 and flip signs where a joint runs
# backwards. Run ArmProcessor::printLimits() to get raw_min / raw_max.
ARM_ANGLE_SCALES = (1.0, 1.0, 1.0)  # degrees per raw unit
ARM_ANGLE_OFFSETS = (0.0, 0.0, 0.0)  # degrees, applied after scale

# False: each joint angle is measured relative to the previous link (0 =
# colinear). True: each is measured from horizontal, independent of upstream
# joints. This is a kinematic difference, not a calibration one — offsets
# cannot compensate for picking the wrong one.
ARM_ANGLES_ABSOLUTE = False

ARM_YAW_INDEX = MOTOR_ID_BASE  # set to None to lock the arm plane
ARM_YAW_SCALE = 1.0
ARM_YAW_OFFSET = 0.0

ARM_CLAW_ROLL_INDEX = MOTOR_ID_CLAW_ROLL  # set to None to keep jaws in-plane
ARM_CLAW_ROLL_SCALE = 1.0
ARM_CLAW_ROLL_OFFSET = 0.0

ARM_GRIPPER_INDEX = MOTOR_ID_CLAW_OPEN  # set to None to pin the jaws open
ARM_GRIPPER_RANGE = (0, 100)  # raw value when closed, raw value when open

SHOULDER_HEIGHT = 0.18  # shoulder pivot above the ground plane
JAW_LENGTH = 0.09
JAW_SPREAD_DEG = 26.0

# Camera / projection
CAM_AZIMUTH_DEG = 38.0
CAM_ELEVATION_DEG = 20.0
CAM_DISTANCE = 2.6
CAM_TARGET = (0.10, 0.0, 0.45)
FOCAL = 270.0
VIEW_W, VIEW_H = 240.0, 220.0
CENTER_X, CENTER_Y = 118.0, 96.0

GRID_EXTENT = 0.70
GRID_STEP = 0.175

LINK_WIDTHS = (0.055, 0.045, 0.030)  # world-space link thickness
JOINT_RADII = (0.048, 0.038, 0.032, 0.026)
LINK_COLORS = ("#6b7889", "#8593a3", "#c1121f")
JOINT_COLOR = "#c1121f"


# --- small vector helpers --------------------------------------------------
def _dot(a, b):
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]


def _cross(a, b):
    return (
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    )


def _unit(v):
    m = math.sqrt(_dot(v, v)) or 1.0
    return (v[0] / m, v[1] / m, v[2] / m)


def _make_camera():
    """Build a perspective projector: world point -> (screen_x, screen_y, depth)."""
    az = math.radians(CAM_AZIMUTH_DEG)
    el = math.radians(CAM_ELEVATION_DEG)
    eye = (
        CAM_TARGET[0] + CAM_DISTANCE * math.cos(el) * math.cos(az),
        CAM_TARGET[1] + CAM_DISTANCE * math.cos(el) * math.sin(az),
        CAM_TARGET[2] + CAM_DISTANCE * math.sin(el),
    )
    fwd = _unit(
        (
            CAM_TARGET[0] - eye[0],
            CAM_TARGET[1] - eye[1],
            CAM_TARGET[2] - eye[2],
        )
    )
    right = _unit(_cross(fwd, (0.0, 0.0, 1.0)))
    up = _cross(right, fwd)

    def project(p):
        v = (p[0] - eye[0], p[1] - eye[1], p[2] - eye[2])
        depth = max(_dot(v, fwd), 1e-3)
        return (
            CENTER_X + FOCAL * _dot(v, right) / depth,
            CENTER_Y - FOCAL * _dot(v, up) / depth,
            depth,
        )

    return project


# --- forward kinematics ----------------------------------------------------
def _arm_chain(joint_angles_deg, yaw_deg, jaw_open, claw_roll_deg=0.0):
    """Return (joint points, jaw tip points) in world space.

    joint points: shoulder, elbow, wrist, claw tip (4 points).
    """
    cumulative = 0.0
    x = z = 0.0
    planar = [(0.0, 0.0)]

    for angle, length in zip(joint_angles_deg, ARM_SEGMENT_LENGTHS):
        if ARM_ANGLES_ABSOLUTE:
            cumulative = math.radians(angle)
        else:
            cumulative += math.radians(angle)
        x += length * math.cos(cumulative)
        z += length * math.sin(cumulative)
        planar.append((x, z))

    joints = [(px, 0.0, pz) for px, pz in planar]

    # Jaw frame at the tip: the claw axis, plus a perpendicular that CLAW_ROLL
    # spins about that axis. Roll 0 splays the jaws in the arm plane; roll 90
    # splays them across it.
    axis = (math.cos(cumulative), 0.0, math.sin(cumulative))
    in_plane = (-math.sin(cumulative), 0.0, math.cos(cumulative))
    roll = math.radians(claw_roll_deg)
    cr, sr = math.cos(roll), math.sin(roll)
    perp = (in_plane[0] * cr, sr, in_plane[2] * cr)

    spread = math.radians(JAW_SPREAD_DEG) * jaw_open
    cs, ss = math.cos(spread), math.sin(spread)
    tip = joints[-1]
    jaws = [
        tuple(
            tip[i] + JAW_LENGTH * (axis[i] * cs + side * perp[i] * ss)
            for i in range(3)
        )
        for side in (1.0, -1.0)
    ]

    yaw = math.radians(yaw_deg)
    cy, sy = math.cos(yaw), math.sin(yaw)

    def to_world(p):
        return (
            p[0] * cy - p[1] * sy,
            p[0] * sy + p[1] * cy,
            p[2] + SHOULDER_HEIGHT,
        )

    return [to_world(p) for p in joints], [to_world(p) for p in jaws]


# --- rendering -------------------------------------------------------------
def _line(a, b, color, width, opacity=1.0):
    return (
        f'<line x1="{a[0]:.2f}" y1="{a[1]:.2f}" x2="{b[0]:.2f}" y2="{b[1]:.2f}" '
        f'stroke="{color}" stroke-width="{width:.2f}" stroke-linecap="round" '
        f'opacity="{opacity}"/>'
    )


def arm_svg(joint_angles_deg, yaw_deg=0.0, jaw_open=1.0, claw_roll_deg=0.0):
    project = _make_camera()
    joints, jaws = _arm_chain(joint_angles_deg, yaw_deg, jaw_open, claw_roll_deg)

    P = [project(p) for p in joints]
    J = [project(p) for p in jaws]
    shadow = [project((p[0], p[1], 0.0)) for p in joints]

    parts = []

    # ground grid
    steps = int(GRID_EXTENT / GRID_STEP)
    for i in range(-steps, steps + 1):
        t = i * GRID_STEP
        emphasis = 0.42 if i == 0 else 0.22
        a = project((t, -GRID_EXTENT, 0.0))
        b = project((t, GRID_EXTENT, 0.0))
        parts.append(_line(a, b, "#7f8c9b", 0.8, emphasis))
        a = project((-GRID_EXTENT, t, 0.0))
        b = project((GRID_EXTENT, t, 0.0))
        parts.append(_line(a, b, "#7f8c9b", 0.8, emphasis))

    # shadow on the ground plane
    shadow_pts = " ".join(f"{p[0]:.2f},{p[1]:.2f}" for p in shadow)
    parts.append(
        f'<polyline points="{shadow_pts}" fill="none" stroke="#000000" '
        f'stroke-width="3" stroke-linecap="round" stroke-linejoin="round" '
        f'opacity="0.16"/>'
    )

    # mast holding the shoulder above the deck
    base = project((joints[0][0], joints[0][1], 0.0))
    parts.append(_line(base, P[0], "#8a95a3", 4.0, 0.85))
    parts.append(
        f'<ellipse cx="{base[0]:.2f}" cy="{base[1]:.2f}" rx="9" ry="3.6" '
        f'fill="#8a95a3" opacity="0.45"/>'
    )

    # depth-sorted arm geometry (far to near)
    drawables = []

    for i in range(3):
        a, b = P[i], P[i + 1]
        depth = (a[2] + b[2]) / 2.0
        width = max(1.5, LINK_WIDTHS[i] * FOCAL / depth)
        drawables.append((depth, _line(a, b, LINK_COLORS[i], width)))

    for jaw in J:
        depth = (P[3][2] + jaw[2]) / 2.0
        width = max(1.2, 0.022 * FOCAL / depth)
        drawables.append((depth, _line(P[3], jaw, "#c1121f", width)))

    for i, p in enumerate(P):
        r = max(1.6, JOINT_RADII[i] * FOCAL / p[2])
        drawables.append(
            (
                p[2],
                f'<circle cx="{p[0]:.2f}" cy="{p[1]:.2f}" r="{r:.2f}" '
                f'fill="{JOINT_COLOR}" stroke="#ffffff" stroke-width="1" '
                f'stroke-opacity="0.55"/>',
            )
        )

    drawables.sort(key=lambda item: -item[0])
    parts.extend(svg for _, svg in drawables)

    return (
        f'<svg viewBox="0 0 {VIEW_W:.0f} {VIEW_H:.0f}" '
        f'xmlns="http://www.w3.org/2000/svg" '
        f'style="width:100%;height:100%;display:block;overflow:visible;">'
        + "".join(parts)
        + "</svg>"
    )


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

    with open("assets/rover-wheel.png", "rb") as f:
        wheel_b64 = base64.b64encode(f.read()).decode()

    # live drive state from MQTT — rover order: [FR, FL, BR, BL]
    drive = st.session_state.motor_data["drive_motor_state"]
    steer = drive["steer"]
    speed = drive["drive"]

    # remap rover order (0=FR 1=FL 2=BR 3=BL) -> grid (tl, tr, bl, br)
    tl, tr, bl, br = steer[1], steer[0], steer[3], steer[2]
    v_tl, v_tr, v_bl, v_br = speed[1], speed[0], speed[3], speed[2]

    def velocity_to_length(v):
        return min(abs(v), 1.0) * 50  # percent; drive is normalized -1..1

    def wheel_html(rotation, velocity, wheel_b64):
        length = velocity_to_length(velocity)
        image_rotation = rotation-90 # rotate wheel image to match steer angle
        if velocity >= 0:
            arrow = f"""
            <div class="arrow-container" style="transform: rotate({image_rotation}deg);">
                <div class="arrow arrow-up" style="height:{length}%;">
                    <div class="arrow-head-up"></div>
                </div>
            </div>
            """
        else:
            arrow = f"""
            <div class="arrow-container" style="transform: rotate({image_rotation}deg);">
                <div class="arrow arrow-down" style="height:{length}%;">
                    <div class="arrow-head-down"></div>
                </div>
            </div>
            """

        return f"""
        <div class="wheel-container">
            <div class="wheel-wrapper">
                <img src="data:image/png;base64,{wheel_b64}"
                    style="transform: rotate({image_rotation}deg);">
                {arrow}
            </div>

            <div class="wheel-readout">
                {(velocity*100):.0f}% · {(rotation):.0f}°
            </div>
        </div>
        """

    tl_html = wheel_html(tl, v_tl, wheel_b64)
    tr_html = wheel_html(tr, v_tr, wheel_b64)
    bl_html = wheel_html(bl, v_bl, wheel_b64)
    br_html = wheel_html(br, v_br, wheel_b64)

    html = f"""
    <style>
    .wheel-wrapper {{
        width: 50px;
        height: 50px;
        position: relative;
        flex-shrink: 0;
    }}

    .wheel-wrapper img {{
        width: 100%;
        height: 100%;
        object-fit: contain;
        transform-origin: center;
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

    .arrow-container {{
        position: absolute;
        width: 100%;
        height: 100%;
        left: 0;
        top: 0;
        transform-origin: center;
    }}

    /* Individual wheel + readout */
    .wheel-container {{
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }}

    /* Whole 2x2 wheel layout */
    .wheels-grid {{
        width: 100%;
        max-width: 220px;
        height: 220px;
        aspect-ratio: 1;
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, 1fr);
        gap: 12px;
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

    <div class="wheels-grid">

        <div class="wheel-cell">{tl_html}</div>
        <div class="wheel-cell">{tr_html}</div>
        <div class="wheel-cell">{bl_html}</div>
        <div class="wheel-cell">{br_html}</div>

    </div>
    """

    with wheels_col:
        components.html(html, height=230, scrolling=False)

        with st.container(key="rover-wheels-text"):
            st.markdown("Wheels")

    # --- arm: 3D triple-pendulum stick figure ------------------------------
    arm_state = st.session_state.motor_data.get("arm_motor_state", {})
    motor_values = arm_state.get("motor_values", [])

    def motor_value(index, default=0.0):
        if index is None or not (0 <= index < len(motor_values)):
            return default
        return float(motor_values[index])

    joint_angles = [
        motor_value(index) * scale + offset
        for index, scale, offset in zip(
            ARM_JOINT_INDICES, ARM_ANGLE_SCALES, ARM_ANGLE_OFFSETS
        )
    ]
    yaw = motor_value(ARM_YAW_INDEX) * ARM_YAW_SCALE + ARM_YAW_OFFSET
    claw_roll = (
        motor_value(ARM_CLAW_ROLL_INDEX) * ARM_CLAW_ROLL_SCALE
        + ARM_CLAW_ROLL_OFFSET
    )

    grip_lo, grip_hi = ARM_GRIPPER_RANGE
    grip_span = (grip_hi - grip_lo) or 1.0
    jaw_open = (motor_value(ARM_GRIPPER_INDEX, grip_hi) - grip_lo) / grip_span
    jaw_open = min(max(jaw_open, 0.0), 1.0)

    readout = " · ".join(
        f"{label} {angle:.0f}°" for label, angle in zip(ARM_JOINT_LABELS, joint_angles)
    )

    arm_html = f"""
    <style>
    .arm-stage {{
        width: 100%;
        max-width: 220px;
        height: 200px;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: center;
    }}
    .arm-readout {{
        margin-top: 4px;
        font-size: 0.8rem;
        font-weight: bold;
        text-align: center;
        white-space: nowrap;
        color: red;
    }}
    </style>

    <div class="arm-stage">{arm_svg(joint_angles, yaw, jaw_open, claw_roll)}</div>
    <div class="arm-readout">{readout}</div>
    """

    with arm_col:
        components.html(arm_html, height=230, scrolling=False)

        with st.container(key="rover-arm-text"):
            st.markdown("Arm")


def display():
    temp = st.empty()

    with temp.container():
        update_telemetry()