"""Enveloppe Streamlit : affiche index.html en plein écran, à la taille de la fenêtre."""
from pathlib import Path

import streamlit as st
import streamlit.components.v1 as components

st.set_page_config(page_title="Ma généalogie", layout="wide", initial_sidebar_state="collapsed")

# Supprime les marges / en-tête de Streamlit et cale la fenêtre sur la hauteur de l'écran
st.markdown(
    """
    <style>
    [data-testid="stHeader"], [data-testid="stToolbar"], [data-testid="stDecoration"], footer {display: none !important;}
    .block-container {padding: 0 !important; max-width: 100% !important;}
    [data-testid="stVerticalBlock"] {gap: 0 !important;}
    div:has(> iframe) {height: 100vh !important;}
    iframe {height: 100vh !important; width: 100% !important; border: 0 !important;}
    [data-testid="stMain"], [data-testid="stAppViewContainer"] {overflow: hidden !important;}
    </style>
    """,
    unsafe_allow_html=True,
)

html = Path(__file__).with_name("index.html").read_text(encoding="utf-8")
components.html(html, height=800, scrolling=True)
