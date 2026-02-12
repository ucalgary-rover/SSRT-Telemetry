import streamlit as st


def display():
    pitch, roll, wheels, arm, power = st.columns(5, vertical_alignment="center")

    with pitch:
        with st.container(key="rover-pitch"):
            st.image("assets/rover-side-view.png", use_container_width=False)
        with st.container(key="rover-pitch-text"):
            st.markdown("Pitch")

    with roll:
        with st.container(key="rover-roll"):
            st.image("assets/rover-front-view.png", use_container_width=False)        
        with st.container(key="rover-roll-text"):
            st.markdown("Roll")

    with wheels:
        with st.container(key="rover-wheels"):
            st.image("assets/rover-wheels.png", use_container_width=False)
        with st.container(key="rover-wheels-text"):
            st.markdown("Wheels")

    with arm:
        with st.container(key="rover-arm"):
            st.image("assets/rover-arm.png", use_container_width=False)
        with st.container(key="rover-arm-text"):
            st.markdown("Arm")

    with power:
        st.text("Battery Temperature")
        st.text("Power")
