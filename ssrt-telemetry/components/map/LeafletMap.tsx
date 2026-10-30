"use client";

import {
  CircleMarker,
  MapContainer,
  Popup,
  TileLayer,
  ZoomControl,
} from "react-leaflet";
import "leaflet/dist/leaflet.css";
import type { MapProps } from "@lib/props";

// If these are ever used anywhere else, move CONSTS to their own file. Keeping them here for now
const MIN_ZOOM: number = 16;
const MAX_ZOOM: number = 20;
const DEFAULT_ZOOM: number = 16;
const MAP_CENTER: [number, number] = [51.463174, -112.709287]; // Downtown Drumheller (Lat: 51.463174° N, Lon: 112.709287° W)
const DEFAULT_LOCATION: [number, number]  = MAP_CENTER;

type Props = {
    gpsLocation?: [number, number];
}

// Leaflet documentation: https://react-leaflet.js.org/docs/start-introduction/
export default function LeafletMap({ gpsLocation }: MapProps) {
  return (
    // The Map component
    <MapContainer
      center={MAP_CENTER}
      zoom={DEFAULT_ZOOM}
      minZoom={MIN_ZOOM}
      maxZoom={MAX_ZOOM}
      zoomControl={false}
      style={{
        height: "50vh",
        width: "50vw",
        minHeight: "30%",
        minWidth: "30%"
      }}
    >
      <ZoomControl position="topright" />

      // Image tiles from the map
      <TileLayer
        url="/tiles/{z}/{x}/{y}.png"
        minZoom={MIN_ZOOM}
        maxZoom={MAX_ZOOM}
        attribution='Imagery "Borrowed" from the Government of Alberta'
      />

      // GPS location marker
      <CircleMarker
        center={gpsLocation || DEFAULT_LOCATION}
        radius={8}
        pathOptions={{ color: "black", fillColor: "magenta", fillOpacity: 0.9 }}
      >
        // Popup for the GPS location marker
        <Popup>
          GPS location
          <br />
          {gpsLocation?.[0] || DEFAULT_LOCATION[0]}, {gpsLocation?.[1] || DEFAULT_LOCATION[1]}
        </Popup>
      </CircleMarker>

    </MapContainer>
  );
}
