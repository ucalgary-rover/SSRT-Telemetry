import json

import streamlit as st
import streamlit.components.v1

from src.utils.components import horizontal_divider

# read required scripts for displaying map
@st.cache_resource
def read_js():
    with open("src/scripts/leaflet.js") as f:
        leaflet_js = f.read()
    with open("src/styles/leaflet.css") as f:
        leaflet_css = f.read()
    with open("src/scripts/vectorgrid.js") as f:
        vectorgrid_js = f.read()
    return leaflet_js, leaflet_css, vectorgrid_js


leaflet_js, leaflet_css, vectorgrid_js = read_js()


def display():
    data = {
        "Latitude": 51.45404,
        "Longitude": -112.67683,
        "MapZoom": 12,
        "Speed": 8.33,
        "POI": 53234,
        "Heading": "random",
    }

    pois = [{"lat": data["Latitude"], "long": data["Longitude"]}]
    with st.container(key="map-container"):
        map, status = st.columns([0.75, 0.25])

        # add the actual map tile here and draw the path on top
        with map:
            map_display(data["Latitude"], data["Longitude"], data["MapZoom"], pois)

        # put the status information to the side
        with status:
            st.image(
                "https://www.shutterstock.com/image-vector/architectural-north-arrow-compass-outline-260nw-2635030447.jpg"
            )
            with st.empty().container():
                st.write(f"SPEED: {data['Speed']}")
                st.text("Add POI Button")

        horizontal_divider()

        lat, long = st.columns(2)

        with lat:
            st.write(f"LAT: {data['Latitude']}")

        with long:
            st.write(f"LONG: {data['Longitude']}")


def map_display(lat: float, long: float, zoom: float, pois: list[dict]):
    print("RENDER MAP")
    pois_json = json.dumps(pois)
    print(pois_json)

    hidden_layer_style = "{ stroke: false, fill: false }"

    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>{leaflet_css}</style>
        <script>{leaflet_js}</script>
        <script>{vectorgrid_js}</script>
        <style>
            html, body, #map {{ height: 100%; margin: 0; padding: 0; }}
        </style>
    </head>
    <body>
        <div id="map"></div>
        <script>
        var map = L.map('map').setView([{lat}, {long}], {zoom});

        L.vectorGrid.protobuf(
        "http://localhost:3650/api/tiles/SSRT_Alberta_tiles/{{z}}/{{x}}/{{y}}",
        {{
            rendererFactory: L.canvas.tile,
            attribution: '&copy; MapTiler &copy; OpenStreetMap contributors',
            vectorTileLayerStyles: {{
                water: {{ fill: true, fillColor: '#a8d4e6', fillOpacity: 1, color: '#a8d4e6', weight: 0 }},
                waterway: {{ color: '#a8d4e6', weight: 1, fill: false }},
                landcover: {{ fill: true, fillColor: '#e8f0e0', fillOpacity: 1, color: 'transparent', weight: 0 }},
                landuse: {{ fill: true, fillColor: '#e0d8cc', fillOpacity: 1, color: 'transparent', weight: 0 }},
                park: {{ fill: true, fillColor: '#c8ddb0', fillOpacity: 1, color: 'transparent', weight: 0 }},
                boundary: {{ color: '#bbbbbb', weight: 1, fill: false }},
                transportation: function(properties) {{
                    var cls = properties.class;
                    if (cls === 'motorway') return {{ color: '#e07020', weight: 3, fill: false }};
                    if (cls === 'trunk' || cls === 'primary') return {{ color: '#f0b040', weight: 2, fill: false }};
                    if (cls === 'secondary' || cls === 'tertiary') return {{ color: '#ffffff', weight: 1.5, fill: false }};
                    return {{ color: '#dddddd', weight: 0.8, fill: false }};
                }},
                building: {{ fill: true, fillColor: '#d4ccc0', fillOpacity: 1, color: '#c0b8b0', weight: 0.3 }},
                place: {hidden_layer_style},
                poi: {hidden_layer_style},
                mountain_peak: {hidden_layer_style},
                transportation_name: {hidden_layer_style},
                water_name: {hidden_layer_style},
                housenumber: {hidden_layer_style},
                highway: {hidden_layer_style},
                admin: {hidden_layer_style},
                road: {hidden_layer_style},
                tunnel: {hidden_layer_style},
                bridge: {hidden_layer_style},
                path: {hidden_layer_style},
                transit: {hidden_layer_style},
            }},
            maxNativeZoom: 14,
            maxZoom: 18,
            getTileUrl: function(coords) {{
                var flippedY = (1 << coords.z) - 1 - coords.y;
                return "http://localhost:3650/api/tiles/SSRT_Alberta_tiles/" + coords.z + "/" + coords.x + "/" + flippedY;
            }}
        }}
        ).addTo(map);

        var pois = {pois_json}

        pois.forEach(function(poi) {{
            L.circleMarker([poi.lat, poi.long], {{
                radius: 8,
                fillColor: '#e63946',
                color: '#ffffff',
                weight: 2,
                fillOpacity: 1,
                stroke: true
            }}).addTo(map).bindPopup('<b>TEST POI</b><br>');
        }});

        </script>
    </body>
    </html>
    """

    streamlit.components.v1.html(html, height=400)
