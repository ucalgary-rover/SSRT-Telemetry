import csv
import hashlib
import io
import json
import secrets
from datetime import datetime

import nh3
import streamlit as st
import streamlit.components.v1

from components.compass import display_compass
from components.shared_components import horizontal_divider
from state.read_latest_from_queue import latest_values
from utils.read_env import read_env_variable

REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))
GNSS_TOPIC = read_env_variable("GNSS_TOPIC")


def _json_for_script(value) -> str:
    """Serialize ``value`` to JSON safe to embed inside an HTML ``<script>`` block.

    ``json.dumps`` alone is unsafe in this context: a string containing
    ``</script>`` (or ``<!--``/``-->``) would let the HTML parser exit the
    script element, allowing HTML/JS injection. We escape ``<``, ``>``, and
    ``&`` to their ``\\u00XX`` form so the HTML parser never sees those
    characters, while the JavaScript parser still decodes the original
    string. U+2028/U+2029 are also escaped because they terminate JS string
    literals.
    """
    encoded = json.dumps(value)
    return (
        encoded.replace("<", "\\u003c")
        .replace(">", "\\u003e")
        .replace("&", "\\u0026")
        .replace("\u2028", "\\u2028")
        .replace("\u2029", "\\u2029")
    )


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
    poi_name = st.session_state.get("poi_name_input", "").strip()

    # sanitize input (prevent XSS)
    poi_name = nh3.clean(poi_name)

    if not poi_name:
        poi_name = f"POI {len(st.session_state.pois) + 1}"

    st.session_state.pois = [
        {
            "latitude": st.session_state.gnss_data["latitude"],
            "longitude": st.session_state.gnss_data["longitude"],
            "colour": "#123D1B",
            "text": poi_name,
        }
    ] + st.session_state.pois

    # Clear the input after adding
    st.session_state.poi_name_input = ""


@st.fragment(run_every=f"{REFRESH_DELAY}s")
def _map_updater():
    gnss_data, updated = latest_values[GNSS_TOPIC].get_if_updated()
    if updated:
        st.session_state.gnss_data = gnss_data

    # check if POIs are updated
    pois_hash = hashlib.md5(
        json.dumps(st.session_state.pois, sort_keys=True).encode()
    ).hexdigest()
    pois_changed = pois_hash != st.session_state.pois_hash
    if pois_changed:
        st.session_state.pois_hash = pois_hash

    if updated and not pois_changed:
        return

    js_data = {
        "lat": st.session_state.gnss_data["latitude"],
        "long": st.session_state.gnss_data["longitude"],
        "nonce": st.session_state.map_nonce,
        **({"pois": st.session_state.pois} if pois_changed else {}),
    }

    update_script = f"""
    <script>
        (function() {{
            const data = {_json_for_script(js_data)};
            const expectedName = "ssrt-map-" + data.nonce;

            // Locate the specific map iframe by the stable window.name
            const parentFrames = window.parent.frames;
            let target = null;
            for (let i = 0; i < parentFrames.length; i++) {{
                try {{
                    if (parentFrames[i].name === expectedName) {{
                        target = parentFrames[i];
                        break;
                    }}
                }} catch (e) {{ /* ignore frames we can't read */ }}
            }}
            if (!target) return;

            try {{
                target.postMessage({{
                    type: "UPDATE_MAP",
                    nonce: data.nonce,
                    lat: data.lat,
                    long: data.long,
                    pois: data.pois
                }}, "*");
            }} catch (e) {{}}
        }})();
    </script>
    """
    streamlit.components.v1.html(update_script, height=0)


@st.fragment(run_every=f"{REFRESH_DELAY}s")
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
            "yaw": 0,
        }
    if "pois" not in st.session_state:
        st.session_state.pois = []
    if "map_nonce" not in st.session_state:
        # Shared secret used to authenticate postMessage updates to the map iframe.
        st.session_state.map_nonce = secrets.token_urlsafe(32)
    if "pois_hash" not in st.session_state:
        st.session_state.pois_hash = ""

    with st.container(key="map-container"):
        map_column, status_column = st.columns([0.75, 0.2])

        with map_column:
            map_display()
            _map_updater()

        with status_column:
            display_compass()
            with st.container():
                st.write(f"SPEED: {st.session_state.imu_data['speed']} km/h")
                col1, col2 = st.columns([3, 1])
                with col1:
                    st.text_input(
                        label="POI name", key="poi_name_input", placeholder="POI name"
                    )
                with col2:
                    st.button(
                        "＋", key="add-poi-button", on_click=handle_poi_button_click
                    )
                display_poi_list()

            display_poi_export()

        horizontal_divider()

        lat_col, long_col = st.columns(2)
        with lat_col:
            lat_placeholder = st.empty()
        with long_col:
            long_placeholder = st.empty()

        _coords_display(lat_placeholder, long_placeholder)


def display_poi_export():
    if not st.session_state.pois:
        return

    buf = io.StringIO()
    writer = csv.writer(buf)
    writer.writerow(["name", "latitude", "longitude"])
    for poi in st.session_state.pois:
        writer.writerow([poi["text"], poi["latitude"], poi["longitude"]])

    st.download_button(
        label="Save POIs",
        data=buf.getvalue().encode("utf-8"),
        file_name=f"{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}-pois.csv",
        mime="text/csv",
    )


def display_poi_list():
    if not st.session_state.pois:
        st.caption("No POIs added yet.")
        return
    with st.container(height=75, border=True, key="pois-list"):
        for i, poi in enumerate(st.session_state.pois):
            col1, col2 = st.columns([0.7, 0.3])
            with col1.container(key=f"poi-label-{i}"):
                st.write(poi["text"])
            if col2.button("✕", key=f"del_poi_{i}"):
                st.session_state.pois.pop(i)
                st.rerun()


def map_display(zoom: float = 12):
    scripts = _load_scripts()

    js_data = {
        "lat": st.session_state.gnss_data["latitude"],
        "long": st.session_state.gnss_data["longitude"],
        "zoom": zoom,
        "pois": st.session_state.pois,
        "tileUrl": _get_tile_url(),
        "nonce": st.session_state.map_nonce,
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
            window.MAP_CONFIG = {_json_for_script(js_data)};
        </script>
        <script>{scripts['map_js']}</script>
    </body>
    </html>
    """

    streamlit.components.v1.html(html, height=405)
