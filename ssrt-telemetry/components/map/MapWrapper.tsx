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

// Need to make a wrapper so that the Leaflet Map component functions correctly
export default function MapWrapper() {
  return <LeafletMap />;
}
