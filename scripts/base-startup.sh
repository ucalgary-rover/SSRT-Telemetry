#!/usr/bin/env bash

cd /home/ssrt/Documents

maptiler-server --workDir MapTiles/ --adminPassword ucalgary-rover &

cd SSRT-Telemetry

source venv/bin/activate

streamlit run app.py
