import json

import streamlit as st
import streamlit.components.v1

from src.utils.components import horizontal_divider
from src.utils.read_env import read_env_variable


@st.cache_resource
def _load_scripts() -> dict[str, str]:
    # extra scripts/css needed
    paths = {
        "leaflet_js": "src/scripts/leaflet.js",
        "leaflet_css": "src/styles/leaflet.css",
        "vectorgrid_js": "src/scripts/vectorgrid.js",
        "map_js": "src/scripts/map.js",
        "map_css": "src/styles/map_styles.css",
    }

    return {key: open(path).read() for key, path in paths.items()}


@st.cache_resource
def _get_tile_url():
    return f'http://localhost:{read_env_variable("MAPTILE_SERVER_PORT")}/api/tiles/{read_env_variable("TILE_NAME")}/{{z}}/{{x}}/{{y}}'


def display():
    # data to be replaced with real data later
    st.session_state.gnss_data = {
        "latitude": 51.45404,
        "longitude": -112.67683,
    }
    st.session_state.imu_data = {
        "speed": 10,  # km/h
        "heading": 0,  # degrees
    }
    st.session_state.pois = [
        {
            "latitude": st.session_state.gnss_data["latitude"],
            "longitude": st.session_state.gnss_data["longitude"],
            "colour": "#AE620B",
            "text": "CURRENT LOCATION",
        },
        {
            "latitude": 51.46942,
            "longitude": -112.71909,
            "colour": "#418092",
            "text": "TEST POI",
        },
    ]

    with st.container(key="map-container"):
        map_column, status_column = st.columns([0.75, 0.25])

        # add the actual map tile here and draw the path on top
        with map_column:
            map_display(
                st.session_state.gnss_data["latitude"],
                st.session_state.gnss_data["longitude"],
                st.session_state.pois,
            )

        # put the status information to the side
        with status_column:
            st.image(
                "https://www.shutterstock.com/image-vector/architectural-north-arrow-compass-outline-260nw-2635030447.jpg"
            )
            with st.container():
                st.write(f"SPEED: {st.session_state.imu_data['speed']}")
                st.text("Add POI Button")

        horizontal_divider()

        lat, long = st.columns(2)

        with lat:
            st.write(f"LAT: {st.session_state.gnss_data['latitude']}")

        with long:
            st.write(f"LONG: {st.session_state.gnss_data['longitude']}")


def map_display(latitude: float, longitude: float, pois: list[dict], zoom: float = 12):
    scripts = _load_scripts()

    js_data = {
        "lat": latitude,
        "long": longitude,
        "zoom": zoom,
        "pois": pois,
        "tileUrl": _get_tile_url(),
    }

    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>{scripts['leaflet_css']}</style>
        <style>{scripts['map_css']}</style>
        <script>{scripts['leaflet_js']}</script>
        <script>{scripts['vectorgrid_js']}</script>
    </head>
    <body>
        <div class="map" id="map"></div>
        <script>
            window.MAP_CONFIG = {json.dumps(js_data)};
        </script>
        <script>{scripts['map_js']}</script>
    </body>
    </html>
    """

    streamlit.components.v1.html(html, height=405)
