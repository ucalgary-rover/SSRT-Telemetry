import logging
import struct

import paho.mqtt.client as mqtt

from mqtt.topics import TOPIC_HANDLERS
from state.read_latest_from_queue import latest_values
from utils.read_env import read_env_variable

logger = logging.getLogger(__name__)


def on_connect(client, userdata, flags, rc, properties=None):
    if rc != 0:
        logger.error(f"Failed to connect to broker, return code {rc}")
        return

    topic_tuples = [(topic, 1) for topic in TOPIC_HANDLERS]
    client.subscribe(topic_tuples)
    logger.info(
        f"Subscribed to {len(topic_tuples)} topics: {list(TOPIC_HANDLERS.keys())}"
    )


def on_message(client, userdata, message):
    handler = TOPIC_HANDLERS.get(message.topic)
    if handler is None:
        logger.warning(f"No handler registered for topic: {message.topic}")
        return

    try:
        data = handler(message.payload)
        latest_values[message.topic].set(data)
        logger.debug(f"{message.topic} → {data}")
    except struct.error as e:
        logger.error(f"Unpack failed on {message.topic}: {e}")


class MQTTSubscriber:
    def __init__(self):
        self._client = mqtt.Client(
            client_id="streamlit_subscriber", protocol=mqtt.MQTTv5
        )
        self._client.on_connect = on_connect
        self._client.on_message = on_message

        host = read_env_variable("ROVER_IP")
        port = int(read_env_variable("MQTT_BROKER_PORT"))

        try:
            self._client.connect(host, port)
            self._client.loop_start()
            logger.info(f"MQTT client connecting to {host}:{port}")
        except Exception as e:
            logger.error(f"Could not connect to broker at {host}:{port}: {e}")
            raise

    def stop(self):
        self._client.loop_stop()
        self._client.disconnect()
        logger.info("MQTT client disconnected")
