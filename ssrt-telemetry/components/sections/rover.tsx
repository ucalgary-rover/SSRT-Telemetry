"use client";

import { useEffect } from "react";
import { useTelemetry } from "@/components/telemetryProvider";
import Wheels from "./wheels";
import "./rover.css";

const LIMIT = 30; // degrees, pitch or roll outside this range flashes red

export default function Rover() {
  const { imu, motor } = useTelemetry();
  const { pitch, roll } = imu;
  const tilted = Math.abs(pitch) > LIMIT || Math.abs(roll) > LIMIT;

  useEffect(() => {
    const root = document.documentElement;
    root.style.setProperty("--pitch-deg", `${-pitch}deg`);
    root.style.setProperty("--roll-deg", `${roll}deg`);
  }, [pitch, roll]);

  useEffect(() => {
    document.body.classList.toggle("tilt-alert", tilted);
    return () => document.body.classList.remove("tilt-alert");
  }, [tilted]);

  const { steer, drive } = motor.drive_motor_state;

  return (
    <div className="rover-health">
      <div>
        <div className="rover-pitch">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src="/assets/rover-side-view.png" alt="" />
        </div>
        <div className="rover-pitch-text">Pitch: {pitch.toFixed(2)}°</div>
      </div>

      <div>
        <div className="rover-roll">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src="/assets/rover-front-view.png" alt="" />
        </div>
        <div className="rover-roll-text">Roll: {roll.toFixed(2)}°</div>
      </div>

      <div>
        <Wheels steer={steer} drive={drive} />
        <div className="rover-wheels-text">Wheels</div>
      </div>

      <div>
        <div className="rover-arm">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src="/assets/rover-arm.png" alt="" />
        </div>
        <div className="rover-arm-text">Arm</div>
      </div>
    </div>
  );
}