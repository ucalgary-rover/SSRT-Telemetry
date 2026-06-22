import struct

from utils.read_env import read_env_variable


def handle_temperature(payload: bytes) -> float:
    (value,) = struct.unpack(read_env_variable("TEMPERATURE_FORMAT"), payload)
    return value


def handle_imu(payload: bytes):
    floats = struct.unpack(read_env_variable("IMU_FORMAT"), payload)
    imu_data = {
        "roll": floats[0],
        "pitch": floats[1],
        "yaw": floats[2],
        "heading_deg": floats[3],
        "speed": floats[4],
    }
    return imu_data


def handle_gnss(payload: bytes):
    (latitude, longitude) = struct.unpack(read_env_variable("GNSS_FORMAT"), payload)

    return {"latitude": latitude, "longitude": longitude}


# add handlers for other sensors here
