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
```sudo apt get-update```

Install Git:
```sudo apt-get install git```

Install Python:
```sudo apt install python3 python3-pip```

## Create a virtual environment

Install venv
```sudo apt install python3-venv```

Create the virtual environment
```python3 -m venv ./.venv```

Activate the virtual environment
```source ./.venv/bin/activate```
Your terminal should now look like this: ```(.venv) danijourdain@Dani-Vivobook:~/SSRT/SSRT-Telemetry```

## Install Streamlit using pip

Install Streamlit
```pip install streamlit```

Verify Streamlit installed correctly
```streamlit hello```

Open the URL in your browser. Should be an address like `http://172.X.X.X:X`

## Install the rest of the requirements for the project

```pip install -r requirements.txt```

## Notes

Please make sure that you are always developing in your virtual environment. If you're ever unsure, run `which python` and ensure the path points to your virtual environment.

If you need new dependencies, please make sure they are added to `requirements.txt` and pushed to GitHub so all members are aware.

Please **DO NOT** push your virtual environment to GitHub.

## Starting Resources

[Streamlit Getting Started](https://docs.streamlit.io/get-started)

[Streamlit Docs](https://docs.streamlit.io/)

[Crash Course Youtube Video](https://youtu.be/20V_ZB7taCM)
