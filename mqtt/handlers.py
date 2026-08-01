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

def handle_motor_state(payload: bytes):
    wheel_count = int(read_env_variable("WHEEL_COUNT"))
    motor_id_end = int(read_env_variable("MOTOR_ID_END"))

    fmt = "<" + "f" * (2 * wheel_count) + "i" * motor_id_end
    values = struct.unpack(fmt, payload)

    steer = values[0:wheel_count]
    drive = values[wheel_count : 2 * wheel_count]
    motor_values = values[2 * wheel_count : 2 * wheel_count + motor_id_end]

    return {
        "drive_motor_state": {"steer": list(steer), "drive": list(drive)},
        "arm_motor_state": {"motor_values": list(motor_values)},
    }
# add handlers for other sensors here
