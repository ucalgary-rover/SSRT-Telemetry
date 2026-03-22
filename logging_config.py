import logging.handlers
from pathlib import Path


def setup_logging():
    log_dir = Path("logs")
    log_dir.mkdir(exist_ok=True)

    formatter = logging.Formatter(
        "%(asctime)s | %(levelname)-8s | %(name)s - %(message)s"
    )

    root = logging.getLogger()
    root.setLevel(logging.DEBUG)

    # rotating file handler so logs don't grow forever
    if not root.handlers:
        file_handler = logging.handlers.RotatingFileHandler(
            log_dir / "app.log", maxBytes=5_000_000, backupCount=3
        )
        file_handler.setFormatter(formatter)

        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)

        root = logging.getLogger()
        root.setLevel(logging.DEBUG)
        root.addHandler(file_handler)
        root.addHandler(console_handler)

    # suppress debug statements from libraries
    logging.getLogger("paho").setLevel(logging.WARNING)
    logging.getLogger("watchdog").setLevel(logging.WARNING)
