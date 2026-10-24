"use client";

import { useEffect, useRef } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import "leaflet.vectorgrid";
import type { Poi } from "@/types/telemetry";

const TILE_URL = `http://localhost:${process.env.NEXT_PUBLIC_MAPTILE_SERVER_PORT}/api/tiles/${process.env.NEXT_PUBLIC_TILE_NAME}/{z}/{x}/{y}`;

type VectorGridFactory = {
  protobuf: (url: string, options: object) => L.Layer;
};

interface Props {
  lat: number;
  long: number;
  pois: Poi[];
}

export default function LiveMap({ lat, long, pois }: Props) {
  const elRef = useRef<HTMLDivElement>(null);
  const roverRef = useRef<L.CircleMarker | null>(null);
  const poiLayerRef = useRef<L.LayerGroup | null>(null);
  const initial = useRef({ lat, long }); // only used to place the map on first load

  useEffect(() => {
    const el = elRef.current;
    if (!el) return;

    const { lat: startLat, long: startLong } = initial.current;
    const map = L.map(el).setView([startLat, startLong], 12);

    const vectorGrid = (L as unknown as { vectorGrid: VectorGridFactory }).vectorGrid;
    vectorGrid
      .protobuf(TILE_URL, {
        vectorTileLayerStyles: {
          // copy your layer styles from map.js here
        },
      })
      .addTo(map);

    roverRef.current = L.circleMarker([startLat, startLong], {
      radius: 8,
      color: "#d00",
      fillOpacity: 0.8,
    }).addTo(map);
    poiLayerRef.current = L.layerGroup().addTo(map);

    return () => {
      map.remove();
    };
  }, []);

  useEffect(() => {
    roverRef.current?.setLatLng([lat, long]);
  }, [lat, long]);

  useEffect(() => {
    const layer = poiLayerRef.current;
    if (!layer) return;
    layer.clearLayers();
    pois.forEach((p) => {
      const tip = document.createElement("span");
      tip.textContent = p.text; // textContent, so a POI name can't inject HTML
      L.circleMarker([p.latitude, p.longitude], { color: p.colour, radius: 6 })
        .bindTooltip(tip)
        .addTo(layer);
    });
  }, [pois]);

  return <div ref={elRef} className="map" />;
}