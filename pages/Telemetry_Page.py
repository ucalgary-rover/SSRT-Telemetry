import pathlib

import streamlit as st
from sections import map, camera, rover, science

from src.utils.read_env import read_env_variable

# defining refresh delay here since it won't change at runtime
REFRESH_DELAY = float(read_env_variable("REFRESH_DELAY"))


def main():
    st.html(pathlib.Path("src/styles/streamlit_styles.css"))
    st.set_page_config(layout="wide")

    # main container
    with st.container(border=True):
        map_col, cam_col, sci_col = st.columns(3, border=True)

        # map
        with map_col:
            map.col()

        # camera preview
        with cam_col:
            camera.col()

        # science data
        with sci_col:
            science.col()

        # rover status
        with st.container(border=True):
            rover.col()


if __name__ == "__main__":
    main()
