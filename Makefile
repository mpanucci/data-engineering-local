.PHONY: build_image
build_image:
	bash ./main.sh build_image $(IMAGE_NAME) $(SERVICE)

.PHONY: start
start:
	bash ./main.sh start_service $(SERVICE)

.PHONY: stop
stop:
	bash ./main.sh stop_service $(SERVICE)