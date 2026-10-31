"use client";

import dynamic from "next/dynamic";
import type { MapProps } from "@lib/props";

import Compass from "@components/map/Compass";

// Need to import LeafletMap dynamically to avoid rendering issues
const LeafletMap = dynamic(
  () => import("./LeafletMap"),
  {
    ssr: false,
    loading: () => (
      <div style={{ height: 600 }}>
        Loading map...
      </div>
    ),
  }
);

// Need to make a wrapper so that the Leaflet Map component functions correctly as per Leaflet documentation
// Leaflet documentation: https://react-leaflet.js.org/docs/start-introduction/
export default function MapWrapper({ gpsLocation }: MapProps) {
  return (
    <div>
      <LeafletMap gpsLocation={gpsLocation} />
      {/* <Compass heading={imu.heading_deg} /> */}
    </div>
  );
}
