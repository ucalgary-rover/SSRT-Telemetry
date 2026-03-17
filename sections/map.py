import json

import streamlit as st
import streamlit.components.v1

from src.components.compass import display_compass
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


def handle_poi_button_click():
    st.session_state.pois = [
        {
            "latitude": st.session_state.gnss_data["latitude"],
            "longitude": st.session_state.gnss_data["longitude"],
            "colour": "#160BAE",
            "text": "NEW POI",
        }
    ] + st.session_state.pois


def display():
    if "gnss_data" not in st.session_state:
        st.session_state.gnss_data = {
            "latitude": 51.45404,
            "longitude": -112.67683,
        }
    if "imu_data" not in st.session_state:
        st.session_state.imu_data = {
            "speed": 10,
            "heading": 0,
            "pitch": 0,
            "roll": 0,
            "battery_temp": 0,
            "power": 0,
        }
    if "pois" not in st.session_state:
        st.session_state.pois = [
            {
                "latitude": 51.46942,
                "longitude": -112.71909,
                "colour": "#418092",
                "text": "TEST POI",
            },
        ]

    with st.container(key="map-container"):
        map_column, status_column = st.columns([0.75, 0.2])

        # add the actual map tile here and draw the path on top
        with map_column:
            map_display()

        # put the status information to the side
        with status_column:
            display_compass()
            # st.image(
            #     "https://www.shutterstock.com/image-vector/architectural-north-arrow-compass-outline-260nw-2635030447.jpg"
            # )
            with st.container():
                st.write(f"SPEED: {st.session_state.imu_data['speed']} km/h")
                st.button("Add POI", on_click=handle_poi_button_click)

        horizontal_divider()

        lat, long = st.columns(2)

        with lat:
            st.write(f"LAT: {st.session_state.gnss_data['latitude']}")

        with long:
            st.write(f"LONG: {st.session_state.gnss_data['longitude']}")


def map_display(zoom: float = 12):
    scripts = _load_scripts()

    js_data = {
        "lat": st.session_state.gnss_data["latitude"],
        "long": st.session_state.gnss_data["longitude"],
        "zoom": zoom,
        "pois": st.session_state.pois,
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

    with st.container(
        key=f"map_{len(st.session_state.pois)}_{st.session_state.gnss_data}"
    ):
        streamlit.components.v1.html(html, height=405)
