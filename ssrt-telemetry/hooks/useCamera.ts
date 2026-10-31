"use client";

import { useEffect, useState } from "react";

const API = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

export const VIDEO_URL = `http://${process.env.NEXT_PUBLIC_ROVER_IP}:${process.env.NEXT_PUBLIC_CAMERA_FEED_PORT}/video_feed/`;

export function useCameras(): number[] {
  const [cameras, setCameras] = useState<number[]>([]);

  useEffect(() => {
    fetch(`${API}/cameras`)
      .then((r) => r.json())
      .then((d: { cameras: number[] }) => setCameras(d.cameras))
      .catch(() => setCameras([]));
  }, []);

  return cameras;
}

export function useCameraControls(
  camId: number | undefined,
  notify: (msg: string) => void
) {
  const [isRecording, setIsRecording] = useState(false);

  // pick up recording state if the page was reloaded mid recording
  useEffect(() => {
    if (camId === undefined) return;
    fetch(`${API}/recording`)
      .then((r) => r.json())
      .then((d: { flags: Record<string, boolean> }) => setIsRecording(!!d.flags[camId]))
      .catch(() => {});
  }, [camId]);

  const post = async (path: string) => {
    const res = await fetch(`${API}/cameras/${camId}/${path}`, { method: "POST" });
    if (!res.ok) {
      const body = await res.json().catch(() => ({ detail: "Request failed" }));
      throw new Error(body.detail);
    }
    return res.json();
  };

  const screenshot = async () => {
    try {
      await post("screenshot");
      notify(`Camera ${camId}: Screenshot saved`);
    } catch (e) {
      notify(`Camera ${camId}: ${e instanceof Error ? e.message : "Screenshot failed"}`);
    }
  };

  const toggleRecord = async () => {
    try {
      const data: { recording: boolean } = await post(
        isRecording ? "record/stop" : "record/start"
      );
      setIsRecording(data.recording);
      notify(
        data.recording
          ? `Recording on camera ${camId}`
          : `Stopped recording camera ${camId}`
      );
    } catch (e) {
      notify(`Camera ${camId}: ${e instanceof Error ? e.message : "Recording failed"}`);
    }
  };

  return { isRecording, screenshot, toggleRecord };
}