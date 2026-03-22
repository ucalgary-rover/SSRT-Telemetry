import struct

import paho.mqtt.client as mqtt

from utils.read_env import get_all_topics
from utils.read_env import read_env_variable


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
    topic_str = get_all_topics()

    topic_tuples = [(topic, 1) for topic in topic_str]

    client.subscribe(topic_tuples)


def on_message(client, userdata, message):
    (temperature,) = struct.unpack(
        read_env_variable("TEMPERATURE_FORMAT"), message.payload
    )
    print(f"GOT DATA {temperature} from {message.topic}")
    message_queue.put(temperature)
