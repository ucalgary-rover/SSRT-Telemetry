(function () {
    const { lat, long, zoom, pois, tileUrl } = window.MAP_CONFIG;

    const vectorTileUrl = tileUrl && typeof tileUrl === "string"
        ? tileUrl.replace("{y}", "{-y}")
        : tileUrl;

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
        .protobuf(vectorTileUrl, {
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
                // hidden layers
                place: hidden, poi: hidden, mountain_peak: hidden,
                aeroway: hidden, runway: hidden, aerodrome_label: hidden,
                transportation_name: hidden, water_name: hidden,
                housenumber: hidden, highway: hidden, admin: hidden,
                road: hidden, tunnel: hidden, bridge: hidden, path: hidden, transit: hidden,

            },
            maxNativeZoom: 14,
            maxZoom: 18,
        })
        .addTo(map);

    pois.forEach(function (poi) {
        const marker = L.circleMarker([poi.latitude, poi.longitude], {
            radius: 8,
            fillColor: poi.colour,
            color: "#ffffff",
            weight: 2,
            fillOpacity: 1,
            stroke: true,
        }).addTo(map);

        const popupContainer = document.createElement("div");
        const boldElement = document.createElement("b");
        boldElement.textContent = poi.text;
        popupContainer.appendChild(boldElement);
        popupContainer.appendChild(document.createElement("br"));

        marker.bindPopup(popupContainer);
    });
})();
