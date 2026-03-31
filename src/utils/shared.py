# For global variables that need to be shared across files
import logging
import queue

global logger
logger = logging.getLogger(__name__)

global temperature_queue
temperature_queue = queue.Queue()

global imu_queue
imu_queue = queue.Queue()
