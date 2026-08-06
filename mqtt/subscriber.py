import logging
import struct

import paho.mqtt.client as mqtt

from mqtt.topics import TOPIC_HANDLERS
from state.read_latest_from_queue import latest_values
from utils.read_env import read_env_variable

logger = logging.getLogger(__name__)

BASE_TOPIC_PREFIX = "base/"


def _split_topics_by_source(topic_handlers):
    """Split TOPIC_HANDLERS into (base_topics, rover_topics) dicts based on prefix."""
    base_topics = {
        t: h for t, h in topic_handlers.items() if t.startswith(BASE_TOPIC_PREFIX)
    }
    rover_topics = {
        t: h for t, h in topic_handlers.items() if not t.startswith(BASE_TOPIC_PREFIX)
    }
    return base_topics, rover_topics


def _make_on_connect(source_name, topics):
    def on_connect(client, userdata, flags, rc, properties=None):
        if rc != 0:
            logger.error(
                f"Failed to connect to {source_name} broker, return code {rc}"
            )
            return

        if not topics:
            logger.info(f"No topics to subscribe to for {source_name} broker")
            return

        topic_tuples = [(topic, 1) for topic in topics]
        client.subscribe(topic_tuples)
        logger.info(
            f"[{source_name}] Subscribed to {len(topic_tuples)} topics: {list(topics.keys())}"
        )

    return on_connect


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


def _build_client(client_id, host, port, source_name, topics):
    client = mqtt.Client(client_id=client_id, protocol=mqtt.MQTTv5)
    client.on_connect = _make_on_connect(source_name, topics)
    client.on_message = on_message

    try:
        client.connect(host, port)
        client.loop_start()
        logger.info(f"[{source_name}] MQTT client connecting to {host}:{port}")
    except Exception as e:
        logger.error(f"[{source_name}] Could not connect to broker at {host}:{port}: {e}")
        raise

    return client


class MQTTSubscriber:
    """
    Subscribes to topics across two brokers:
      - Topics starting with "base/" are subscribed to via BASE_STATION_IP.
      - All other topics are subscribed to via ROVER_IP.

    Required env vars:
      - ROVER_IP
      - MQTT_BROKER_PORT
      - BASE_STATION_IP        (new; only needed if any "base/" topics exist)

    Optional env vars (fall back to sane defaults so setup stays minimal):
      - BASE_STATION_MQTT_PORT (defaults to MQTT_BROKER_PORT if unset)
    """

    def __init__(self):
        self._clients = []

        base_topics, rover_topics = _split_topics_by_source(TOPIC_HANDLERS)

        rover_host = read_env_variable("ROVER_IP")
        rover_port = int(read_env_variable("MQTT_BROKER_PORT"))

        # Rover client always starts, even if it ends up with zero topics,
        # so behavior stays predictable if TOPIC_HANDLERS changes later.
        rover_client = _build_client(
            client_id="streamlit_subscriber_rover",
            host=rover_host,
            port=rover_port,
            source_name="rover",
            topics=rover_topics,
        )
        self._clients.append(rover_client)

        if base_topics:
            base_host = read_env_variable("BASE_STATION_IP")
            # Reuse the rover port by default so users only need to add one
            # new env var (BASE_STATION_IP) in the common case.
            base_port = int(
                read_env_variable("BASE_STATION_MQTT_PORT", default=rover_port)
            )

            base_client = _build_client(
                client_id="streamlit_subscriber_base",
                host=base_host,
                port=base_port,
                source_name="base",
                topics=base_topics,
            )
            self._clients.append(base_client)
        else:
            logger.info(
                f'No topics starting with "{BASE_TOPIC_PREFIX}" found in TOPIC_HANDLERS; '
                "base station broker connection skipped."
            )

    def stop(self):
        for client in self._clients:
            client.loop_stop()
            client.disconnect()
        logger.info("MQTT client(s) disconnected")