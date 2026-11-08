"""Enveloppe Streamlit : affiche index.html tel quel dans la page."""
from pathlib import Path

import streamlit as st
import streamlit.components.v1 as components

st.set_page_config(page_title="Ma généalogie", layout="wide", initial_sidebar_state="collapsed")

# Retire les marges de Streamlit pour que l'appli occupe tout l'écran
st.markdown(
    "<style>.block-container{padding:0 !important;max-width:100% !important}"
    "header[data-testid='stHeader']{display:none}</style>",
    unsafe_allow_html=True,
)

html = Path(__file__).with_name("index.html").read_text(encoding="utf-8")
components.html(html, height=1100, scrolling=True)
