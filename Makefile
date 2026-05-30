
# Start telemetry frontend
.PHONY: run
run:
	streamlit run ./app.py

# Install dependencies
.PHONY: setup
setup:
	chmod +x install.sh
	./install.sh

# Start MQTT broker container
.PHONY: broker
broker:
	docker compose up -d
