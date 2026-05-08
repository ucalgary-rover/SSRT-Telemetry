(function () {
    const { lat, long, zoom, pois, tileUrl } = window.MAP_CONFIG;

    const map = L.map("map").setView([lat, long], zoom);

    const roadStyles = {
        motorway: { color: "#e07020", weight: 3 },
        trunk: { color: "#f0b040", weight: 2 },
        primary: { color: "#f0b040", weight: 2 },
        secondary: { color: "#ffffff", weight: 1.5 },
        tertiary: { color: "#ffffff", weight: 1.5 },
    };
    const hidden = { stroke: false, fill: false };

    L.vectorGrid
        .protobuf(tileUrl, {
            rendererFactory: L.canvas.tile,
            attribution: "&copy; MapTiler &copy; OpenStreetMap contributors",
            vectorTileLayerStyles: {
                water: { fill: true, fillColor: "#a8d4e6", fillOpacity: 1, color: "#a8d4e6", weight: 0 },
                waterway: { color: "#a8d4e6", weight: 1, fill: false },
                landcover: { fill: true, fillColor: "#e8f0e0", fillOpacity: 1, color: "transparent", weight: 0 },
                landuse: { fill: true, fillColor: "#e0d8cc", fillOpacity: 1, color: "transparent", weight: 0 },
                park: { fill: true, fillColor: "#c8ddb0", fillOpacity: 1, color: "transparent", weight: 0 },
                boundary: { color: "#bbbbbb", weight: 1, fill: false },
                building: { fill: true, fillColor: "#d4ccc0", fillOpacity: 1, color: "#c0b8b0", weight: 0.3 },
                transportation: function (props) {
                    return roadStyles[props.class] || { color: "#dddddd", weight: 0.8, fill: false };
                },
                place: hidden, poi: hidden, mountain_peak: hidden,
                aeroway: hidden, runway: hidden, aerodrome_label: hidden,
                transportation_name: hidden, water_name: hidden,
                housenumber: hidden, highway: hidden, admin: hidden,
                road: hidden, tunnel: hidden, bridge: hidden, path: hidden, transit: hidden,
            },
            maxNativeZoom: 14,
            maxZoom: 18,
            getTileUrl: function (coords) {
                const flippedY = (1 << coords.z) - 1 - coords.y;
                return `${tileUrl}/${coords.z}/${coords.x}/${flippedY}`;
            },
        })
        .addTo(map);

    // --- Vehicle marker ---
    const vehicleMarker = L.circleMarker([lat, long], {
        radius: 8,
        fillColor: "#c95323",
        color: "#ffffff",
        weight: 2,
        fillOpacity: 1,
        stroke: true,
    }).addTo(map);

    // --- POI layer ---
    const poiLayer = L.layerGroup().addTo(map);

    function renderPois(poisData) {
        // Check if any POI popup is currently open
        let openPopupLatLng = null;
        poiLayer.eachLayer(function(layer) {
            if (layer.isPopupOpen()) {
                openPopupLatLng = layer.getLatLng();
            }
        });

        poiLayer.clearLayers();

        poisData.forEach(function (poi) {
            const marker = L.circleMarker([poi.latitude, poi.longitude], {
                radius: 8,
                fillColor: poi.colour,
                color: "#ffffff",
                weight: 2,
                fillOpacity: 1,
                stroke: true,
            })
                .addTo(poiLayer)
                .bindPopup("<b>" + poi.text + "</b>");

            // Re-open popup if this marker had it open before
            if (openPopupLatLng &&
                marker.getLatLng().lat === openPopupLatLng.lat &&
                marker.getLatLng().lng === openPopupLatLng.lng) {
                marker.openPopup();
            }
        });
    }

    // Render initial POIs
    renderPois(pois);

    // --- postMessage listener for live updates ---
    window.addEventListener("message", function (event) {
        if (!event.data || event.data.type !== "UPDATE_MAP") return;

        const { lat: newLat, long: newLong, pois: newPois } = event.data;

        vehicleMarker.setLatLng([newLat, newLong]);
        map.panTo([newLat, newLong]);

        if (newPois) {
            renderPois(newPois);
        }
    });

})();
