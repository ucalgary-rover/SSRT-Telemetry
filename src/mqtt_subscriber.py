import paho.mqtt.client as mqtt

from src.utils.read_env import read_env_variable
from src.utils.shared import imu_queue
from src.utils.shared import temperature_queue


class MQTTSubscriber:
    def __init__(self):
        client = mqtt.Client(client_id="streamlit_subscriber", protocol=mqtt.MQTTv5)
        client.on_connect = on_connect
        client.on_message = on_message

        client.connect(
            read_env_variable("ROVER_IP"), int(read_env_variable("MQTT_BROKER_PORT"))
        )
        client.loop_start()  # run MQTT network


# MQTT callbacks
def on_connect(client, userdata, flags, rc, properties=None):
    client.subscribe(read_env_variable("SAMPLE_TOPIC"))
    client.subscribe(read_env_variable("IMU_TOPIC"))


def on_message(client, userdata, message):
    # Store the latest value in session_state

    # Important to differentiate data based on topic to make sure nothing bleeds where it isn't supposed to go
    if message.topic == read_env_variable("SAMPLE_TOPIC"):
        temperature_queue.put(message.payload.decode())
    elif message.topic == read_env_variable("IMU_TOPIC"):
        imu_queue.put(message.payload.decode())
