# Setting up Ubuntu on Windows on Ubuntu Environment

WSL setup for building and testing Streamlit on Windows with Linux WSL.

## Prerequisities

Windows 10 Build 19044+ or Windows 11

## WSL Installation

On Powershell run:
```wsl --install --distribution Ubuntu-22.04```

On Windows, this distribution is now accessible as an application.

## Installing Python with WSL

Update distribution:
```sudo apt-get update```

Install Git:
```sudo apt-get install git```

Install Python:
```sudo apt install python3 python3-pip```

## Starting Resources

[Streamlit Getting Started](https://docs.streamlit.io/get-started)

[Streamlit Docs](https://docs.streamlit.io/)

[Crash Course Youtube Video](https://youtu.be/20V_ZB7taCM)
