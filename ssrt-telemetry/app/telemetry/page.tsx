"use client";

import { useState } from "react";
import MapSection from "@/components/sections/mapSection";
import CameraPreview from "@/components/sections/cameraPreview";
import Rover from "@/components/sections/rover";

export default function TelemetryPage() {
  const [toast, setToast] = useState("");
  const notify = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(""), 3000);
  };

  return (
    <div className="telemetry">
      <div className="top-row">
        <MapSection />
        <CameraPreview notify={notify} />
      </div>
      <Rover />
      {toast && <div className="toast">{toast}</div>}
    </div>
  );
}