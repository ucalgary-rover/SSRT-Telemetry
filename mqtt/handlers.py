import struct

from utils.read_env import read_env_variable


def handle_temperature(payload: bytes) -> float:
    (value,) = struct.unpack(read_env_variable("TEMPERATURE_FORMAT"), payload)
    return value


# add handlers for other sensors here
