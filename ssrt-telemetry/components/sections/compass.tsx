const POINTS = [
  { label: "N", angle: 0 },
  { label: "E", angle: 90 },
  { label: "S", angle: 180 },
  { label: "W", angle: 270 },
];

const TICKS = Array.from({ length: 12 }, (_, i) => i * 30);

export default function Compass({ heading }: { heading: number }) {
  const normalized = ((heading % 360) + 360) % 360;

  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
      <svg viewBox="-60 -60 120 120" width="100%" style={{ maxWidth: 140 }}>
        {/* the dial turns opposite to the heading, so N stays pointed at north */}
        <g transform={`rotate(${-normalized})`}>
          <circle r="50" fill="none" stroke="currentColor" strokeWidth="2" opacity="0.6" />

          {TICKS.map((a) => (
            <line
              key={a}
              x1="0"
              y1="-44"
              x2="0"
              y2="-50"
              stroke="currentColor"
              strokeWidth="1.5"
              transform={`rotate(${a})`}
            />
          ))}

          {POINTS.map(({ label, angle }) => (
            <text
              key={label}
              x={36 * Math.sin((angle * Math.PI) / 180)}
              y={-36 * Math.cos((angle * Math.PI) / 180)}
              textAnchor="middle"
              dominantBaseline="central"
              fontSize="14"
              fontWeight="bold"
              fill={label === "N" ? "red" : "currentColor"}
            >
              {label}
            </text>
          ))}
        </g>

        {/* fixed pointer at the top shows the way the rover is facing */}
        <polygon points="0,-58 -5,-48 5,-48" fill="red" />
      </svg>

      <div style={{ fontWeight: "bold" }}>HDG: {normalized.toFixed(0)}°</div>
    </div>
  );
}