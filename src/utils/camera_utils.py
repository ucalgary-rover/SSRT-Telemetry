import requests

from src.utils.read_env import read_env_variable

BASE_URL = (
    f"http://{read_env_variable('ROVER_IP')}:{read_env_variable('CAMERA_FEED_PORT')}"
)


def get_available_cameras():
    try:
        response = requests.get(f"{BASE_URL}/available_cameras")
        response.raise_for_status()
        return response.json().get("cameras", [])
    except Exception:
        return []
