"use client";

import { useState } from "react";
import Link from "next/link";
import { VIDEO_URL, useCameras, useCameraControls } from "@/hooks/useCamera";

export default function CameraPreview({
  notify,
}: {
  notify: (msg: string) => void;
}) {
  const cameras = useCameras();
  const [selected, setSelected] = useState<number | null>(null);
  const [rot, setRot] = useState<Record<number, number>>({}); // rotation per camera
  const camId = selected ?? cameras[0];
  const deg = camId !== undefined ? rot[camId] ?? 0 : 0;
  const { isRecording, screenshot, toggleRecord } = useCameraControls(camId, notify);
  const none = cameras.length === 0;

  return (
    <div className="camera-container">
      <div className="camera-controls">
        <select
          value={camId ?? ""}
          disabled={none}
          onChange={(e: React.ChangeEvent<HTMLSelectElement>) =>
            setSelected(Number(e.target.value))
          }
        >
          {none ? (
            <option>No cameras detected</option>
          ) : (
            cameras.map((id) => (
              <option key={id} value={id}>
                Camera {id}
              </option>
            ))
          )}
        </select>

        <button
          disabled={none}
          onClick={() => {
            if (camId !== undefined) setRot({ ...rot, [camId]: (deg + 90) % 360 });
          }}
        >
          Rotate
        </button>
        <button disabled={none} onClick={screenshot}>
          Screenshot
        </button>
        <button disabled={none} onClick={toggleRecord}>
          {isRecording ? "Stop" : "Record"}
        </button>
        <Link href="/cameras" className="popout">
          ↗
        </Link>
      </div>

      <hr />

      <div className="camera-preview">
        {none || camId === undefined ? (
          "No cameras detected"
        ) : (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={`${VIDEO_URL}${camId}`}
            alt=""
            style={{
              position: "absolute",
              top: "50%",
              left: "50%",
              width: "100%",
              height: "100%",
              transform: `translate(-50%, -50%) rotate(${deg}deg)`,
            }}
          />
        )}
      </div>
    </div>
  );
}