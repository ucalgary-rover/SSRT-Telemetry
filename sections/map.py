import pandas as pd
import streamlit as st
import streamlit.components.v1

from src.utils.components import horizontal_divider


def display():
    data = {
        "Longitude": 6.44,
        "Latitude": 7.44,
        "Speed": 8.33,
        "POI": 53234,
        "Heading": "random",
    }

    df = pd.DataFrame({"lat": [37.76, 37.77, 37.78], "lon": [-122.4, -122.41, -122.42]})
    with st.container(key="map-container"):
        map, status = st.columns([0.75, 0.25])

        # add the actual map tile here and draw the path on top
        with map:
            map_display()
            # st.map(df)

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


def map_display():
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
        <script src="https://unpkg.com/leaflet.vectorgrid@latest/dist/Leaflet.VectorGrid.bundled.js"></script>
        <style>
            html, body, #map { height: 100%; margin: 0; padding: 0; }
        </style>
    </head>
    <body>
        <div id="map"></div>
        <script>
            var map = L.map('map').setView([51.45404, -112.67683], 12);

    L.vectorGrid.protobuf(
        "http://localhost:3650/api/tiles/SSRT_Alberta_tiles/{z}/{x}/{y}",
        {
                rendererFactory: L.canvas.tile,
                attribution: '&copy; MapTiler &copy; OpenStreetMap contributors',
                vectorTileLayerStyles: {
                    water: { fill: true, fillColor: '#a8d4e6', fillOpacity: 1, color: '#a8d4e6', weight: 0 },
                    waterway: { color: '#a8d4e6', weight: 1, fill: false },
                    landcover: { fill: true, fillColor: '#e8f0e0', fillOpacity: 1, color: 'transparent', weight: 0 },
                    landuse: { fill: true, fillColor: '#e0d8cc', fillOpacity: 1, color: 'transparent', weight: 0 },
                    park: { fill: true, fillColor: '#c8ddb0', fillOpacity: 1, color: 'transparent', weight: 0 },
                    boundary: { color: '#bbbbbb', weight: 1, fill: false },
                    transportation: function(properties) {
                        var cls = properties.class;
                        if (cls === 'motorway') return { color: '#e07020', weight: 3, fill: false };
                        if (cls === 'trunk' || cls === 'primary') return { color: '#f0b040', weight: 2, fill: false };
                        if (cls === 'secondary' || cls === 'tertiary') return { color: '#ffffff', weight: 1.5, fill: false };
                        return { color: '#dddddd', weight: 0.8, fill: false };
                    },
                    building: { fill: true, fillColor: '#d4ccc0', fillOpacity: 1, color: '#c0b8b0', weight: 0.3 },
                    place: { weight: 0, fill: false, opacity: 0, fillOpacity: 0 },
                    poi: { weight: 0, fill: false, opacity: 0, fillOpacity: 0 },
                    mountain_peak: { weight: 0, fill: false, opacity: 0, fillOpacity: 0 },
                    aeroway: { color: '#e0e0e0', weight: 1, fill: false },
                    transportation_name: { weight: 0, fill: false, opacity: 0, fillOpacity: 0 },
                    water_name: { weight: 0, fill: false, opacity: 0, fillOpacity: 0 }
                },
                maxNativeZoom: 14,
                maxZoom: 18,
                getTileUrl: function(coords) {
                    var flippedY = (1 << coords.z) - 1 - coords.y;
                    return "http://localhost:3650/api/tiles/SSRT_Alberta_tiles/" + coords.z + "/" + coords.x + "/" + flippedY;
                }
            }
        ).addTo(map);
        </script>
    </body>
    </html>
    """

    streamlit.components.v1.html(html, height=400)
