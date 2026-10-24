"use client";

import { createContext, useContext, useEffect, useState, type ReactNode } from "react";
import type { Telemetry } from "@/types/telemetry";

const DEFAULT: Telemetry = {
  imu: { roll: 0, pitch: 0, yaw: 0, heading_deg: 0, speed: 0 },
  gnss: { latitude: 51.45404, longitude: -112.67683 },
  motor: {
    drive_motor_state: { steer: [0, 0, 0, 0], drive: [0, 0, 0, 0] },
    arm_motor_state: { motor_values: Array(7).fill(0) },
  },
};

const TelemetryContext = createContext<Telemetry>(DEFAULT);

export function TelemetryProvider({ children }: { children: ReactNode }) {
  const [data, setData] = useState<Telemetry>(DEFAULT);

  useEffect(() => {
    let ws: WebSocket | undefined;
    let timer: ReturnType<typeof setTimeout> | undefined;
    let closed = false;

    const connect = () => {
      ws = new WebSocket("ws://localhost:8000/ws/telemetry");
      ws.onmessage = (e) =>
        setData((prev) => ({ ...prev, ...(JSON.parse(e.data) as Partial<Telemetry>) }));
      ws.onclose = () => {
        if (!closed) timer = setTimeout(connect, 1000);
      };
    };
    connect();

    return () => {
      closed = true;
      clearTimeout(timer);
      ws?.close();
    };
  }, []);

  return <TelemetryContext.Provider value={data}>{children}</TelemetryContext.Provider>;
}

export const useTelemetry = () => useContext(TelemetryContext);