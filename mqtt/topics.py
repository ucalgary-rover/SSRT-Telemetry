from collections.abc import Callable

from mqtt.handlers import *
from utils.read_env import read_env_variable

TOPIC_HANDLERS: dict[str, Callable] = {
    read_env_variable("SAMPLE_TOPIC"): handle_temperature,
    read_env_variable("SAMPLE_TOPIC2"): handle_temperature,
    # read_env_variable("HUMIDITY_TOPIC"):    handle_humidity,
    # read_env_variable("GPS_TOPIC"):         handle_gps,
}
