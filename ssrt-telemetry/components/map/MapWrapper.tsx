"use client";

import dynamic from "next/dynamic";

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
  return <LeafletMap />;
}
