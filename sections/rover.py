import streamlit as st


def display():
    pitch, roll, wheels, arm, power = st.columns(5)

    with pitch:
        st.text("Pitch")

    with roll:
        st.text("Roll")

    with wheels:
        st.text("Wheels")

    with arm:
        st.text("Arm")

    with power:
        st.text("Battery Temperature")
        st.text("Power")
        st.text("Power")
