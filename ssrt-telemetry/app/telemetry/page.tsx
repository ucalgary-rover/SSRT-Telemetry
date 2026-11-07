"use client";

import MapWrapper from "@/components/map/MapWrapper";
import { useState } from "react";
import CameraPreview from "@/components/sections/cameraPreview";
import Rover from "@/components/sections/rover";

export default function TelemetryPage() {
  const [toast, setToast] = useState("");
  const notify = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(""), 3000);
  };

  return (
    <div className="flex-1 p-4 [&_button]:cursor-pointer [&_button]:rounded-md [&_button]:border [&_button]:border-[#8888] [&_button]:bg-transparent [&_button]:px-[10px] [&_button]:py-1 [&_button]:font-[inherit] [&_button]:text-inherit [&_button:disabled]:cursor-not-allowed [&_button:disabled]:opacity-50 [&_input]:rounded-md [&_input]:border [&_input]:border-[#8888] [&_input]:bg-transparent [&_input]:px-[10px] [&_input]:py-1 [&_input]:font-[inherit] [&_input]:text-inherit [&_select]:rounded-md [&_select]:border [&_select]:border-[#8888] [&_select]:bg-transparent [&_select]:px-[10px] [&_select]:py-1 [&_select]:font-[inherit] [&_select]:text-inherit">
      <div className="mb-4 grid grid-cols-2 gap-4">
        <MapWrapper />
        <CameraPreview notify={notify} />
      </div>
      <Rover />
      {toast && <div className="fixed bottom-4 right-4 z-[1000] rounded-md bg-[#222] px-4 py-3 text-white">{toast}</div>}
    </div>
  );
}
