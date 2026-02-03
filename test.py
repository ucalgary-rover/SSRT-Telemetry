"""
GPS Route Tracker — Streamlit (done right)

Uses native Streamlit primitives where they belong:
  • st.metric()            → SPEED / LAT / LONG readouts
  • st.columns()           → all layout
  • st.sidebar             → POI list with delete buttons
  • st.session_state       → mutable state (POIs, position, clicked loc)
  • streamlit-folium       → map + click-event capture
  • streamlit-autorefresh  → auto-ticks position forward (simulated live GPS)

Install:
    pip install streamlit folium streamlit-folium streamlit-autorefresh

Run:
    streamlit run gps_tracker_app.py
"""
import math

import folium
import streamlit as st
from streamlit_autorefresh import st_autorefresh
from streamlit_folium import st_folium

# ─── PAGE CONFIG ────────────────────────────────────────────────────────────
st.set_page_config(
    page_title="GPS Route Tracker",
    layout="wide",
    initial_sidebar_state="expanded",
)

# ─── TINY CSS RESET (only what Streamlit can't do natively) ─────────────────
st.markdown(
    """
    <style>
        /* tighten default top padding so the metrics sit flush */
        .block-container { padding-top: 0.6rem !important; padding-bottom: 0.4rem !important; }
        /* make metric labels uppercase + spaced */
        [data-testid="stMetricLabel"] {
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-size: 0.72rem !important;
        }
        /* slightly bolder metric values */
        [data-testid="stMetricValue"] { font-weight: 700 !important; }
    </style>
    """,
    unsafe_allow_html=True,
)

# ─── CONSTANTS ──────────────────────────────────────────────────────────────
ROUTE = [
    (51.2780, -112.7870),
    (51.2795, -112.7920),
    (51.2815, -112.7950),
    (51.2840, -112.7940),
    (51.2870, -112.7900),
    (51.2890, -112.7830),
    (51.2880, -112.7750),
    (51.2850, -112.7700),
    (51.2820, -112.7720),
    (51.2790, -112.7780),
    (51.2770, -112.7830),
    (51.2760, -112.7870),
    (51.2770, -112.7900),
]

DEFAULT_POIS = [
    {"id": 1, "lat": 51.2840, "lon": -112.7940, "name": "Drumheller Public Library"},
    {"id": 2, "lat": 51.2820, "lon": -112.7720, "name": "Badlands Community Facility"},
    {"id": 3, "lat": 51.2770, "lon": -112.7900, "name": "Sun Country"},
]

# ─── HELPERS ────────────────────────────────────────────────────────────────
def haversine_km(lat1, lon1, lat2, lon2):
    R = 6371
    dlat, dlon = math.radians(lat2 - lat1), math.radians(lon2 - lon1)
    a = (
        math.sin(dlat / 2) ** 2
        + math.cos(math.radians(lat1))
        * math.cos(math.radians(lat2))
        * math.sin(dlon / 2) ** 2
    )
    return R * 2 * math.asin(math.sqrt(a))


def total_route_km():
    return sum(haversine_km(*ROUTE[i], *ROUTE[i + 1]) for i in range(len(ROUTE) - 1))


# ─── SESSION STATE INIT ─────────────────────────────────────────────────────
st.session_state.setdefault("pois", list(DEFAULT_POIS))
st.session_state.setdefault("pos_idx", 0)
st.session_state.setdefault("next_id", 4)
st.session_state.setdefault("last_clicked", None)
st.session_state.setdefault("auto_advance", False)

# ─── AUTO-REFRESH (only ticks when auto-advance is on) ──────────────────────
# Runs every 2 seconds; we only actually advance inside the logic below.
tick = st_autorefresh(interval=2000, limit=None, key="autorefresh_ticker")

# ─── SIDEBAR — POI LIST ─────────────────────────────────────────────────────
with st.sidebar:
    st.header("📍 Points of Interest", divider="rainbow")

    if not st.session_state.pois:
        st.caption("No POIs yet. Click the map then hit **Add POI**.")
    else:
        for poi in list(st.session_state.pois):  # iterate a copy
            col_name, col_del = st.columns([5, 1], gap="small")
            col_name.markdown(
                f"**{poi['name']}**\n`{poi['lat']:.4f}, {poi['lon']:.4f}`"
            )
            if col_del.button("✕", key=f"del_{poi['id']}", help="Remove"):
                st.session_state.pois = [
                    p for p in st.session_state.pois if p["id"] != poi["id"]
                ]
                st.rerun()

    st.divider()
    st.subheader("Route Info")
    st.metric("Total Distance", f"{total_route_km()*1000:.0f} m")
    st.metric("Waypoints", len(ROUTE))
    st.metric("POIs", len(st.session_state.pois))

# ─── CURRENT POSITION ───────────────────────────────────────────────────────
idx = st.session_state.pos_idx % len(ROUTE)
cur_lat, cur_lon = ROUTE[idx]
next_idx = (idx + 1) % len(ROUTE)
seg_km = haversine_km(cur_lat, cur_lon, *ROUTE[next_idx])
speed_kmh = round(seg_km * 3600 / 5, 1)  # pretend each segment takes 5 s

# ─── AUTO-ADVANCE TICK ──────────────────────────────────────────────────────
if st.session_state.auto_advance:
    st.session_state.pos_idx = (st.session_state.pos_idx + 1) % len(ROUTE)
    idx = st.session_state.pos_idx
    cur_lat, cur_lon = ROUTE[idx]

# ─── TOP METRICS ROW  (Speed | Lat | Long | Compass) ───────────────────────
top_c1, top_c2, top_c3, top_c4 = st.columns([2, 2.5, 2.5, 1], gap="small")

top_c1.metric("⚡ Speed", f"{speed_kmh} km/h")
top_c2.metric("📍 Latitude", f"{cur_lat:.6f}")
top_c3.metric("📍 Longitude", f"{cur_lon:.6f}")

# Compass — an SVG is genuinely the right tool here (no Streamlit widget for this)
top_c4.markdown(
    """
    <div style="display:flex;flex-direction:column;align-items:center;padding-top:4px;">
      <svg width="44" height="44" viewBox="0 0 44 44">
        <circle cx="22" cy="22" r="20" fill="#f0f2f5" stroke="#c0c6cf" stroke-width="1.5"/>
        <polygon points="22,5 18,22 22,18 26,22" fill="#e74c3c"/>
        <polygon points="22,39 18,22 22,26 26,22" fill="#aab2bd"/>
        <circle cx="22" cy="22" r="2.5" fill="#2c3e50"/>
      </svg>
      <span style="font-size:10px;color:#6c757d;font-weight:600;margin-top:1px;">N 0°</span>
    </div>
    """,
    unsafe_allow_html=True,
)

# ─── MAIN ROW: Map | Controls ───────────────────────────────────────────────
map_col, ctrl_col = st.columns([4, 1], gap="small")

# ── MAP ──
with map_col:
    centre = (
        sum(p[0] for p in ROUTE) / len(ROUTE),
        sum(p[1] for p in ROUTE) / len(ROUTE),
    )
    m = folium.Map(
        location=centre, zoom_start=14, tiles="CartoDB positron", control_scale=True
    )

    # route
    folium.PolyLine(ROUTE, color="#8B4513", weight=5, opacity=0.9).add_to(m)

    # start / end
    folium.Marker(
        ROUTE[0],
        icon=folium.Icon(color="green", icon="play", prefix="fa"),
        tooltip="Start",
    ).add_to(m)
    folium.Marker(
        ROUTE[-1],
        icon=folium.Icon(color="red", icon="flag", prefix="fa"),
        tooltip="End",
    ).add_to(m)

    # POI markers
    for poi in st.session_state.pois:
        folium.CircleMarker(
            [poi["lat"], poi["lon"]],
            radius=8,
            color="#fff",
            weight=2,
            fill=True,
            fill_color="#8B4513",
            fill_opacity=0.95,
            tooltip=poi["name"],
            popup=folium.Popup(
                f"<b>{poi['name']}</b><br/>{poi['lat']:.4f}, {poi['lon']:.4f}",
                max_width=180,
            ),
        ).add_to(m)

    # current-position marker (blue)
    folium.CircleMarker(
        [cur_lat, cur_lon],
        radius=9,
        color="#fff",
        weight=3,
        fill=True,
        fill_color="#3498db",
        fill_opacity=1.0,
        tooltip=f"Current: {cur_lat:.4f}, {cur_lon:.4f}",
    ).add_to(m)

    # If user has clicked somewhere, show a temporary red pin
    if st.session_state.last_clicked:
        lc = st.session_state.last_clicked
        folium.Marker(
            [lc["lat"], lc["lng"]],
            icon=folium.Icon(color="red", icon="map-pin", prefix="fa"),
            tooltip="Click location — press Add POI to pin",
        ).add_to(m)

    # render & capture click
    map_data = st_folium(m, width="100%", height=480, returned_objects=["last_clicked"])

    # persist clicked location into session state
    if map_data and map_data.get("last_clicked"):
        st.session_state.last_clicked = map_data["last_clicked"]

# ── CONTROL PANEL ──
with ctrl_col:
    st.subheader("Controls")

    # ── Add POI ──
    if st.button(
        "📍 Add POI",
        use_container_width=True,
        type="primary",
        help="Pins a POI at your last map click (or map centre)",
    ):
        loc = st.session_state.last_clicked or {"lat": centre[0], "lng": centre[1]}
        st.session_state.pois.append(
            {
                "id": st.session_state.next_id,
                "lat": round(loc["lat"], 4),
                "lon": round(loc["lng"], 4),
                "name": f"POI #{st.session_state.next_id}",
            }
        )
        st.session_state.next_id += 1
        st.session_state.last_clicked = None  # clear the red pin
        st.rerun()

    # ── Manual advance ──
    if st.button(
        "▶ Advance",
        use_container_width=True,
        help="Step current position one waypoint forward",
    ):
        st.session_state.pos_idx = (st.session_state.pos_idx + 1) % len(ROUTE)
        st.rerun()

    st.divider()

    # ── Auto-advance toggle ──
    st.session_state.auto_advance = st.toggle(
        "🔄 Auto-advance",
        value=st.session_state.auto_advance,
        help="Automatically moves the position every 2 seconds",
    )

    st.divider()

    # ── Reset ──
    if st.button(
        "🔁 Reset", use_container_width=True, help="Reset position and POIs to defaults"
    ):
        st.session_state.pois = list(DEFAULT_POIS)
        st.session_state.pos_idx = 0
        st.session_state.next_id = 4
        st.session_state.last_clicked = None
        st.rerun()

    # current-position info card (small, native)
    st.info(f"Position #{idx + 1}/{len(ROUTE)}\n`{cur_lat:.5f}, {cur_lon:.5f}`")
