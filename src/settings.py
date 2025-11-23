import queue

BROKER = "127.0.0.1"
PORT = 1883
TOPIC = "sensors/temperature"


def init():
    global message_queue
    message_queue = queue.Queue()

    global refresh_delay
    refresh_delay = 0.5
