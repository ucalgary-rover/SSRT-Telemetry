const normAngle = (a: number): number => {
  const m = ((a % 360) + 360) % 360; // JS % can go negative, Python's can't
  return m > 180 ? m - 360 : m;
};

function Wheel({ rotation, velocity }: { rotation: number; velocity: number }) {
  const length = Math.min(Math.abs(velocity), 1) * 50;
  const dir = velocity >= 0 ? "up" : "down";

  return (
    <div className="wheel-container">
      <div className="wheel-wrapper">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src="/assets/rover-wheel.png"
          alt=""
          style={{ transform: `rotate(${rotation}deg)` }}
        />
        <div
          className="arrow-container"
          style={{ transform: `rotate(${rotation}deg)` }}
        >
          <div className={`arrow arrow-${dir}`} style={{ height: `${length}%` }}>
            <div className={`arrow-head-${dir}`} />
          </div>
        </div>
      </div>
      <div className="wheel-readout">
        {(velocity * 100).toFixed(0)}% · {normAngle(rotation).toFixed(0)}°
      </div>
    </div>
  );
}

export default function Wheels({
  steer,
  drive,
}: {
  steer: number[];
  drive: number[];
}) {
  // rover order is [FR, FL, BR, BL], grid order is [tl, tr, bl, br]
  return (
    <div className="wheels-grid">
      {[1, 0, 3, 2].map((i) => (
        <div className="wheel-cell" key={i}>
          <Wheel rotation={steer[i]} velocity={drive[i]} />
        </div>
      ))}
    </div>
  );
}