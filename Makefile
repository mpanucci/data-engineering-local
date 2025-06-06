# Makefile for managing Docker images and services

# Default target: Display help.
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make help                  - Show this help message."
	@echo "  make all                   - Build all images and start all services (placeholder)."
	@echo "  make list_services         - List available services (directories in the current path)."
	@echo "  make build_image SERVICE=<service_dir> IMAGE_NAME=<image_name> - Build a Docker image for a specific service."
	@echo "                             IMAGE_NAME defaults to SERVICE if not set."
	@echo "  make start SERVICE=<service_dir>       - Start a specific service."
	@echo "  make stop SERVICE=<service_dir>        - Stop a specific service."

# All target: Placeholder for building all images and starting services.
.PHONY: all
all:
	@echo "Building all images and starting all services (placeholder)..."
	# This target can be expanded to call other targets, e.g., build_image for key services.

# List services: Shows available service directories.
# Excludes common infrastructure/tooling directories if they are not built/run this way.
.PHONY: list_services
list_services:
	@echo "Available services (directories):"
	@ls -d */ | grep -v -E '^(minio/|mongodb/|postgres/|nifi_data/|jupyter_data/|docs/|scripts/|tests/|venv/|__pycache__/|\.git/|\.vscode/)' || echo "No service directories found or all are excluded."

# Build a Docker image for a specific service.
# Requires SERVICE (directory of the service) and optionally IMAGE_NAME.
# If IMAGE_NAME is not provided, it defaults to the SERVICE name.
.PHONY: build_image
build_image:
ifndef SERVICE
	$(error SERVICE is not set. Usage: make build_image SERVICE=<service_dir> [IMAGE_NAME=<image_name>])
endif
	bash ./main.sh build_image $(or $(IMAGE_NAME),$(SERVICE)) $(SERVICE)

# Start a specific service.
# Requires SERVICE (directory of the service).
.PHONY: start
start:
ifndef SERVICE
	$(error SERVICE is not set. Usage: make start SERVICE=<service_dir>)
endif
	bash ./main.sh start_service $(SERVICE)

# Stop a specific service.
# Requires SERVICE (directory of the service).
.PHONY: stop
stop:
ifndef SERVICE
	$(error SERVICE is not set. Usage: make stop SERVICE=<service_dir>)
endif
	bash ./main.sh stop_service $(SERVICE)