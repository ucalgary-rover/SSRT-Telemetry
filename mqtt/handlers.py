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
        "battery_temp": floats[3],
        "power": floats[4],
        "heading_deg": floats[5],
        "speed": floats[6],
    }
    return imu_data


# add handlers for other sensors here
