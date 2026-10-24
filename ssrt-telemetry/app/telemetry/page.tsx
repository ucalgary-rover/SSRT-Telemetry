import MapWrapper from "@/components/map/MapWrapper";

export default function Home() {
  return (
    <div className="flex flex-col flex-1 items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      Temp Telemetry Page
      <MapWrapper />
    </div>
  );
}
