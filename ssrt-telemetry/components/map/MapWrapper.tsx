"use client";

import dynamic from "next/dynamic";
import { useTelemetry } from "@/lib/functions/telemetry";
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
export default function MapWrapper() {
  const { gnss, imu } = useTelemetry();
  let gpsLocation: [number, number] = [gnss.latitude, gnss.longitude] as [number, number];

  return (
    <div>
      <LeafletMap gpsLocation={gpsLocation} />
      <Compass heading={imu.heading_deg} />
      <span>LAT: {gpsLocation[0].toFixed(10)}</span>
      <span>LONG: {gpsLocation[1].toFixed(10)}</span>
    </div>
  );
}
