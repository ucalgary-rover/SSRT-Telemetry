import streamlit as st

pitch = -15
roll = 24
battery_temp = 42
power = 69

def display():
    st.markdown(f"""
        <style>
        :root {{
            --pitch-deg: {pitch}deg;
            --roll-deg: {roll}deg;
        }}
        </style>
    """, unsafe_allow_html=True)
    
    pitch_col, roll_col, wheels_col, arm_col, power_col = st.columns(5, vertical_alignment="top")

    with pitch_col:
        with st.container(key="rover-pitch"):
            st.image("assets/rover-side-view.png", width='content')
        with st.container(key="rover-pitch-text"):
            st.markdown("Pitch: %0.2f°" % pitch)

    with roll_col:
        with st.container(key="rover-roll"):
            st.image("assets/rover-front-view.png", width='content')        
        with st.container(key="rover-roll-text"):
            st.markdown("Roll: %0.2f°" % roll)

    with wheels_col:
        with st.container(key="rover-wheels"):
            st.image("assets/rover-wheels.png", width='content')
        with st.container(key="rover-wheels-text"):
            st.markdown("Wheels")

    with arm_col:
        with st.container(key="rover-arm"):
            st.image("assets/rover-arm.png", width='content')
        with st.container(key="rover-arm-text"):
            st.markdown("Arm")

    with power_col:
        with st.container(key="battery-temp-text"):
            st.markdown("Battery Temperature")
        with st.container(key="battery-temp"):
            st.markdown("%0.2f°C" % battery_temp)
        with st.container(key="power-text"):
            st.markdown("Power")
        with st.container(key="power"):    
            st.markdown("%0.2f%%" % power)
