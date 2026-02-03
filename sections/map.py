import streamlit as st

from src.components import horizontal_divider


def display():
    with st.container(key="map-container"):
        map, status = st.columns([0.75, 0.25])

        # add the actual map tile here and draw the path on top
        with map:
            st.text("Map")

        # put the status information to the side
        with status:
            st.text("Heading")
            st.text("Speed")
            st.text("Add POI Button")

        horizontal_divider()

        lat, long = st.columns(2)

        with lat:
            st.text("Latitude")

        with long:
            st.text("Longitude")
