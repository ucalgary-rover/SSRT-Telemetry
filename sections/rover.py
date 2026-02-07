import streamlit as st


def display():
    pitch, roll, wheels, arm, power = st.columns(5)

    with pitch:
        with st.container(key="rover-pitch"):
            st.image("assets/rover-side-view.png", use_container_width=False)
        st.text("Pitch")

    with roll:
        with st.container(key="rover-roll"):
            st.image("assets/rover-front-view.png", use_container_width=False)
        st.text("Roll")

    with wheels:
        with st.container(key="rover-wheels"):
            st.image("assets/rover-wheels.png", use_container_width=False)
        st.text("Wheels")

    with arm:
        st.image("assets/rover-arm.png", use_container_width=False)
        st.text("Arm")

    with power:
        st.text("Battery Temperature")
        st.text("Power")
        st.text("Power")
