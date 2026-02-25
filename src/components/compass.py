import math

import streamlit as st


def _get_direction_from_angle(angle) -> str:
    # angle = st.session_state.imu_data["heading"]

    if angle > 337.5 or angle < 22.5:
        return "N"
    elif angle < 67.5:
        return "NE"
    elif angle < 112.5:
        return "E"
    elif angle < 157.5:
        return "SE"
    elif angle < 202.5:
        return "S"
    elif angle < 247.5:
        return "SW"
    elif angle < 292.5:
        return "W"
    else:
        return "NW"


def compass_svg(angle: float, width: int = 120, height: int = 140):
    angle_rad = math.radians(angle)

    centre_x, centre_y = 60, 60
    radius = 45

    # tip of the compass
    tip_x = centre_x + (radius * 0.7) * math.sin(angle_rad)
    tip_y = centre_y - (radius * 0.7) * math.cos(angle_rad)

    # tail of the compass
    tail_x = centre_x - (radius * 0.7) * math.sin(angle_rad)
    tail_y = centre_y + (radius * 0.7) * math.cos(angle_rad)

    # middle wide part of compass
    perp_x = math.cos(angle_rad)
    perp_y = math.sin(angle_rad)

    width_left_x = centre_x - (radius * 0.1) * math.cos(angle_rad)
    width_left_y = centre_y - (radius * 0.1) * math.sin(angle_rad)

    width_right_x = centre_x + (radius * 0.1) * math.cos(angle_rad)
    width_right_y = centre_y + (radius * 0.1) * math.sin(angle_rad)

    compass_svg = f"""
        <svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
            <!-- needle -->
            <polygon points="{tip_x},{tip_y} {width_left_x},{width_left_y} {width_right_x},{width_right_y}" fill="#c95323" stroke-width="1" stroke="#c95323"/>
            <polygon points="{tail_x},{tail_y} {width_left_x},{width_left_y} {width_right_x},{width_right_y}" stroke="#c95323" stroke-width="1" fill="none"/>
            <!-- outer circle -->
            <circle cx="{centre_x}" cy="{centre_y}" r="{radius}" stroke="#72351E" stroke-width="3" fill="none" />
        </svg>
    """
    return compass_svg


def display_compass():
    st.session_state.imu_data["heading"] = st.slider("Heading (°)", 0, 359, 45)

    st.markdown(
        compass_svg(st.session_state.imu_data["heading"]), unsafe_allow_html=True
    )
    st.text(
        f"{_get_direction_from_angle(st.session_state.imu_data['heading'])}, {st.session_state.imu_data['heading']}°"
    )
