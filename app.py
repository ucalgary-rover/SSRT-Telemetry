import queue
import time

import paho.mqtt.client as mqtt
import streamlit as st

BROKER = "127.0.0.1"
PORT = 1883
TOPIC = "sensors/temperature"

st.title("Live Temperature Monitor")

if "latest_temp" not in st.session_state:
    st.session_state.latest_temp = "Waiting..."

msg_q = queue.Queue()


# MQTT callbacks
def on_connect(client, userdata, flags, rc, properties=None):
    client.subscribe(TOPIC)


def on_message(client, userdata, message):
    # Store the latest value in session_state
    print(f"GOT { message.payload.decode()}")
    msg_q.put(message.payload.decode())

    st.session_state.latest_temp = message.payload.decode()
    st.rerun()


# MQTT client setup
client = mqtt.Client(client_id="streamlit_subscriber", protocol=mqtt.MQTTv5)
client.on_connect = on_connect
client.on_message = on_message

client.connect(BROKER)
client.loop_start()  # run MQTT network loop in background thread

# Display
slot = st.empty()
slot.metric("Temperature", st.session_state.latest_temp)


while True:
    updated = False
    while not msg_q.empty():
        st.session_state.latest_temp = msg_q.get_nowait()
        updated = True

    if updated:
        slot.metric("Temperature", st.session_state.latest_temp)

    time.sleep(0.5)
