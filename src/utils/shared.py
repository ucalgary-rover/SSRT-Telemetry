# For global variables that need to be shared across files
import logging
import queue

global logger
logger = logging.getLogger(__name__)

global message_queue
message_queue = queue.Queue()
