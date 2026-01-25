#!/usr/bin/env bash
set -e

VENV_DIR="venv"

# 1) Ensure apt is available
if ! command -v apt &> /dev/null; then
  echo "Error: this script assumes a Debian/Ubuntu system with apt."
  exit 1
fi

# 2) Install python3 if needed
if ! command -v python3 &> /dev/null; then
  echo "python3 not found—installing via apt..."
  sudo apt update
  sudo apt install -y python3 python3-venv python3-pip
else
  echo "python3 is already installed: $(python3 --version)"
  # Ensure venv & pip are available
  if ! python3 -m venv --help &> /dev/null; then
    echo "python3-venv not found—installing..."
    sudo apt update
    sudo apt install -y python3-venv
  fi
  if ! command -v pip3 &> /dev/null; then
    echo "pip3 not found—installing..."
    sudo apt update
    sudo apt install -y python3-pip
  fi
fi

# 3) Create the virtual environment
if [ -d "${VENV_DIR}" ]; then
  echo "Warning: ${VENV_DIR}/ already exists; reusing it."
else
  echo "Creating virtual environment in ./${VENV_DIR}..."
  python3 -m venv "${VENV_DIR}"
fi

# 4) Activate and install
echo "Activating virtual environment..."
# shellcheck disable=SC1090
source "${VENV_DIR}/bin/activate"

echo "Upgrading pip, setuptools, wheel..."
pip install --upgrade pip setuptools wheel

echo "Installing dependencies: opencv-python, opencv-contrib-python, psutil, flask"
pip install opencv-python opencv-contrib-python psutil flask

echo
echo ":white_check_mark: Setup complete!"
echo ":point_right: To start using your venv:"
echo "     source ${VENV_DIR}/bin/activate"
echo "     streamlit run app.py"
