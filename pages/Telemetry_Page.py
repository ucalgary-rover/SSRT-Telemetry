import pathlib

import streamlit as st

from sections import camera
from sections import map
from sections import rover
from src.utils.read_env import read_env_variable

# defining refresh delay here since it won't change at runtime
REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))


def main():
    st.set_page_config(page_title="SSRT Telemetry", layout="wide")

    st.html(pathlib.Path("src/styles/streamlit_styles.css"))
    st.html(pathlib.Path("src/styles/telemetry_styles.css"))
    map_col, cam_col = st.columns(2)

    with map_col:
        map.display()

    with cam_col:
        camera.display()

    with st.container(key="rover-health"):
        rover.display()


if __name__ == "__main__":
    main()
