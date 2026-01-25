import pathlib

import streamlit as st

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
            st.text("Map")

        # camera preview
        with cam_col:
            st.text("Camera Preview")

        # science data
        with sci_col:
            st.text("Science")

        # rover status
        with st.container(border=True):
            st.text("Rover")


if __name__ == "__main__":
    main()
