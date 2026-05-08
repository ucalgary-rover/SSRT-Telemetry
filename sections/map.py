import json

import streamlit as st
import streamlit.components.v1

from components.compass import display_compass
from components.shared_components import horizontal_divider
from state.read_latest_from_queue import latest_values
from utils.read_env import read_env_variable

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))
GNSS_TOPIC = read_env_variable("GNSS_TOPIC")


@st.cache_resource
def _load_scripts() -> dict[str, str]:
    paths = {
        "leaflet_js": "static/scripts/leaflet.js",
        "leaflet_css": "static/styles/leaflet.css",
        "vectorgrid_js": "static/scripts/vectorgrid.js",
        "map_js": "static/scripts/map.js",
        "map_css": "static/styles/map_styles.css",
    }

    map = {}
    for key, path in paths.items():
        with open(path) as f:
            map[key] = f.read()

    return map


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


@st.fragment(run_every=f"{read_env_variable('REFRESH_DELAY')}s")
def _map_updater():
    gnss_data, updated = latest_values[GNSS_TOPIC].get_if_updated()
    if updated:
        st.session_state.gnss_data = gnss_data

    js_data = {
        "lat": st.session_state.gnss_data["latitude"],
        "long": st.session_state.gnss_data["longitude"],
        "pois": st.session_state.pois,
    }

    update_script = f"""
    <script>
        (function() {{
            const data = {json.dumps(js_data)};
            // Target the map iframe specifically by its position in the DOM
            const frames = window.parent.document.querySelectorAll("iframe");
            frames.forEach(function(frame) {{
                try {{
                    frame.contentWindow.postMessage({{
                        type: "UPDATE_MAP",
                        lat: data.lat,
                        long: data.long,
                        pois: data.pois
                    }}, "*");
                }} catch(e) {{}}
            }});
        }})();
    </script>
    """
    streamlit.components.v1.html(update_script, height=0)


@st.fragment(run_every=f"{read_env_variable('REFRESH_DELAY')}s")
def _coords_display(lat_col, long_col):
    with lat_col:
        st.write(f"LAT: {st.session_state.gnss_data['latitude']}")
    with long_col:
        st.write(f"LONG: {st.session_state.gnss_data['longitude']}")


def display():
    # Default session state
    if "gnss_data" not in st.session_state:
        st.session_state.gnss_data = {"latitude": 51.45404, "longitude": -112.67683}
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

        with map_column:
            map_display()
            _map_updater()

        with status_column:
            display_compass()
            with st.container():
                st.write(f"SPEED: {st.session_state.imu_data['speed']} km/h")
                st.button("Add POI", on_click=handle_poi_button_click)

        horizontal_divider()

        lat_col, long_col = st.columns(2)
        with lat_col:
            lat_placeholder = st.empty()
        with long_col:
            long_placeholder = st.empty()

        _coords_display(lat_placeholder, long_placeholder)


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

    streamlit.components.v1.html(html, height=405)
