import streamlit as st


def horizontal_divider(colour="#72351E", thickness=2, full_width=True):
    """
    Divider to vertically separate the contents of a container. Will stretch the entire width of the container it's placed in

    :param colour: Colour the divider should be (hex code)
    :param thicknes: How thick the divider should be (px)
    :param full_width: If the divider bar should take up the width of its container. NOTE: This assumes this method is being called in an `st.container()` NOT an `st.column()`
    """

    full_width_css = (
        "margin-left: -1rem; margin-right: -1rem; width: calc(100% + 2rem);"
        if full_width is True
        else ""
    )

    st.markdown(
        f"""<hr
                style='border:none;
                border-top:{thickness}px solid {colour}; {full_width_css}'>""",
        unsafe_allow_html=True,
    )
