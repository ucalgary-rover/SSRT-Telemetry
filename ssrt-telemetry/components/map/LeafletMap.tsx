"use client";

import {
  MapContainer,
  TileLayer,
  ZoomControl,
} from "react-leaflet";

import "leaflet/dist/leaflet.css";

// Leaflet documentation: https://react-leaflet.js.org/docs/start-introduction/
export default function LeafletMap() {
  return (
    <MapContainer
      center={[51.5, -112.5]}
      zoom={12}
      minZoom={8}
      maxZoom={19}
      zoomControl={false}
      style={{ height: "600px", width: "100%" }}
    >
      <ZoomControl position="topright" />

      <TileLayer
        url="/map_tiles/{z}/{x}/{y}.png"
        minZoom={8}
        maxZoom={19}
        attribution="Imagery © Government of Alberta"
      />
    </MapContainer>
  );
}
