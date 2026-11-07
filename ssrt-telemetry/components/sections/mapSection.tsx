"use client";

import { useState } from "react";
import dynamic from "next/dynamic";
import { useTelemetry } from "@/lib/functions/telemetry";
import type { Poi } from "@/types/telemetry";   
import Compass from "../map/Compass";

// Leaflet touches window on import, so it can't render on the server
const LiveMap = dynamic(() => import("./liveMap"), { ssr: false });

const DECIMALS = Number(process.env.NEXT_PUBLIC_DECIMAL_PLACES ?? 2);

const makeId = (): string =>
  globalThis.crypto?.randomUUID?.() ?? String(Date.now() + Math.random());

export default function MapSection() {
  const { gnss, imu } = useTelemetry();
  const [pois, setPois] = useState<Poi[]>([]);
  const [name, setName] = useState("");

  const addPoi = () => {
    const text = name.trim() || `POI ${pois.length + 1}`;
    setPois([
      {
        id: makeId(),
        latitude: gnss.latitude,
        longitude: gnss.longitude,
        colour: "#123D1B",
        text,
      },
      ...pois,
    ]);
    setName("");
  };

  const exportCsv = () => {
    const esc = (v: string | number) => `"${String(v).replaceAll('"', '""')}"`;
    const rows: (string | number)[][] = [
      ["name", "latitude", "longitude"],
      ...pois.map((p) => [p.text, p.latitude, p.longitude]),
    ];
    const csv = rows.map((r) => r.map(esc).join(",")).join("\n");
    const blob = new Blob([csv], { type: "text/csv" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = `${new Date().toISOString().replace(/[:.]/g, "_")}_pois.csv`;
    a.click();
    URL.revokeObjectURL(a.href);
  };

  return (
    <div className="rounded-lg border border-[#8884] p-3">
      <div className="grid grid-cols-[3fr_1fr] gap-4">
        <LiveMap lat={gnss.latitude} long={gnss.longitude} pois={pois} />

        <div className="flex flex-col gap-2">
          <Compass heading={imu.heading_deg} />
          <div>SPEED: {imu.speed.toFixed(DECIMALS)} km/h</div>

          <div className="flex gap-1">
            <input
              value={name}
              placeholder="POI name"
              onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                setName(e.target.value)
              }
              onKeyDown={(e: React.KeyboardEvent<HTMLInputElement>) => {
                if (e.key === "Enter") addPoi();
              }}
            />
            <button onClick={addPoi}>＋</button>
          </div>

          {pois.length === 0 ? (
            <small>No POIs added yet.</small>
          ) : (
            <ul className="m-0 max-h-[75px] list-none overflow-y-auto rounded-md border border-[#8884] p-0">
              {pois.map((p) => (
                <li key={p.id} className="flex items-center justify-between px-1.5 py-0.5">
                  <span>{p.text}</span>
                  <button onClick={() => setPois(pois.filter((x) => x.id !== p.id))}>
                    ✕
                  </button>
                </li>
              ))}
            </ul>
          )}

          {pois.length > 0 && <button onClick={exportCsv}>Save POIs</button>}
        </div>
      </div>

      <hr />

      <div className="flex justify-around">
        <span>LAT: {gnss.latitude.toFixed(10)}</span>
        <span>LONG: {gnss.longitude.toFixed(10)}</span>
      </div>
    </div>
  );
}
