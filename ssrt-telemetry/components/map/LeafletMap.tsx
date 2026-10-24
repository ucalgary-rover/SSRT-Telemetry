"use client";

import {
  MapContainer,
  TileLayer,
  ZoomControl,
} from "react-leaflet";

import "leaflet/dist/leaflet.css";

// Should more CONSTS to their own file. Keeping them here for now
// const MAP_CENTER: [number, number] = [51.463174, -112.709287]; // Downtown Drumheller (Lat: 51.463174° N, Lon: 112.709287° W)
const MAP_CENTER: [number, number] = [51.478839, -112.783798]; // Royal Tyrell Museum (Lat: 51.478839° N, Lon: 112.783798° W)
// Leaflet documentation: https://react-leaflet.js.org/docs/start-introduction/
export default function LeafletMap() {
  return (
    <MapContainer
      center={MAP_CENTER}
      zoom={19}
      minZoom={19}
      maxZoom={22}
      zoomControl={false}
      style={{ height: "600px", width: "100%" }}
    >
      <ZoomControl position="topright" />

      <TileLayer
        url="/tiles/{z}/{x}/{y}.png"
        minZoom={19}
        maxZoom={22}
        attribution='Imagery "Borrowed" from the Government of Alberta'
      />
    </MapContainer>
  );
}
