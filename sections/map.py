import streamlit as st
import pandas as pd

from src.components import horizontal_divider


def display():
    data = {"Longitude": 6.44,
            "Latitude": 7.44,
            "Speed": 8.33,
            "POI": 53234,
            "Heading": "random"}
    
    df = pd.DataFrame({
        "lat": [37.76, 37.77, 37.78],
        "lon": [-122.4, -122.41, -122.42]
    })
    with st.container(key="map-container"):
        map, status = st.columns([0.75, 0.25])

        # add the actual map tile here and draw the path on top
        with map:
            st.map(df)

        # put the status information to the side
        with status:
            st.image("https://www.shutterstock.com/image-vector/architectural-north-arrow-compass-outline-260nw-2635030447.jpg")
            with st.empty().container():
                st.write(f"SPEED: {data['Speed']}")
                st.text("Add POI Button")

        horizontal_divider()

        lat, long = st.columns(2)

        with lat:
            st.write(f"LAT: {data['Latitude']}")

        with long:
            st.write(f"LONG: {data['Longitude']}")
