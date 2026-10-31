from threading import Lock

from utils.read_env import get_all_topics


class ReadLatestFromQueue:
    def __init__(self) -> None:
        self._value = None
        self._lock = Lock()
        self._updated = False

    def set(self, value):
        with self._lock:
            self._value = value
            self._updated = True

    def get_if_updated(self):
        with self._lock:
            # there was no new data
            if not self._updated:
                return None, False

            # reading data, update is false
            self._updated = False

            return self._value, True


latest_values: dict[str, ReadLatestFromQueue] = {
    f"{topic}": ReadLatestFromQueue() for topic in get_all_topics()
}
