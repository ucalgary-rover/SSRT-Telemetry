import streamlit as st

from src.components import horizontal_divider


def display():
    with st.container(key="camera-container"):
        dropdown_select, blank, popout = st.columns([0.4, 0.2, 0.1])

        with dropdown_select:
            st.text("Camera dropdown select")

        with popout:
            st.text("Popout")

        horizontal_divider()

        st.text("Camera Display")
