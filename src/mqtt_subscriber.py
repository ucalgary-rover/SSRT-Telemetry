import paho.mqtt.client as mqtt

from src import settings


class MQTTSubscriber:
    def __init__(self):
        client = mqtt.Client(client_id="streamlit_subscriber", protocol=mqtt.MQTTv5)
        client.on_connect = on_connect
        client.on_message = on_message

        client.connect(settings.BROKER)
        client.loop_start()  # run MQTT network


# MQTT callbacks
def on_connect(client, userdata, flags, rc, properties=None):
    client.subscribe(settings.TOPIC)


def on_message(client, userdata, message):
    # Store the latest value in session_state
    settings.message_queue.put(message.payload.decode())
