CONTAINER_NAME_JUPYTER=pyspark-local
JUPYTER_LOCAL_FOLDER=jupyter-local

build_docker_jupyter:
	@bash -c ". ./functions.sh build_image $(CONTAINER_NAME_JUPYTER)"

start_docker_jupyter:
	@bash -c ". ./functions.sh start_jupyter $(CONTAINER_NAME_JUPYTER)"

start_docker_minio:
	@bash -c ". ./functions.sh start_minio"

stop_docker_jupyter:
	@bash -c ". ./functions.sh stop_jupyter $(CONTAINER_NAME_JUPYTER)"

stop_docker_minio:
	@bash -c ". ./functions.sh stop_minio"
