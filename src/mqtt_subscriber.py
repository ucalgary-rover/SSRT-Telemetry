import struct

import paho.mqtt.client as mqtt

from src.utils.read_env import read_env_variable
from src.utils.shared import message_queue


class MQTTSubscriber:
    def __init__(self):
        client = mqtt.Client(client_id="streamlit_subscriber", protocol=mqtt.MQTTv5)
        client.on_connect = on_connect
        client.on_message = on_message
        client.connect(
            read_env_variable("ROVER_IP"), int(read_env_variable("MQTT_BROKER_PORT"))
        )
        client.loop_start()


# MQTT callbacks
def on_connect(client, userdata, flags, rc, properties=None):
    client.subscribe(read_env_variable("TOPIC"))


def on_message(client, userdata, message):
    (temperature,) = struct.unpack(
        read_env_variable("TEMPERATURE_FORMAT"), message.payload
    )
    print(f"GOT DATA {temperature}")
    message_queue.put(temperature)
