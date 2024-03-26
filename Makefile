CONTAINER_NAME_JUPYTER=pyspark-local
JUPYTER_LOCAL_FOLDER=jupyter-local

build_jupyter:
	@bash -c ". ./functions.sh build_image $(CONTAINER_NAME_JUPYTER)"

start_jupyter:
	@bash -c ". ./functions.sh start_jupyter $(CONTAINER_NAME_JUPYTER)"

stop_jupyter:
	@bash -c ". ./functions.sh stop_jupyter $(CONTAINER_NAME_JUPYTER)"

start_minio:
	@bash -c ". ./functions.sh start_minio"

stop_minio:
	@bash -c ". ./functions.sh stop_minio"

start_postgresql:
	@bash -c ". ./functions.sh start_postgresql"

stop_postgresql:
	@bash -c ". ./functions.sh stop_postgresql"

start_mysql:
	@bash -c ". ./functions.sh start_mysql"

stop_mysql:
	@bash -c ". ./functions.sh stop_mysql"

start_mongodb:
	@bash -c ". ./functions.sh start_mongodb"

stop_mongodb:
	@bash -c ". ./functions.sh stop_mongodb"