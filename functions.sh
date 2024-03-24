#!/bin/bash

build_image() {
    IMAGE_NAME=${1?'Name of image'}
    DIRECTORY=${2:-'jupyter-local'}
    DIR_NOTEBOOK='notebooks'
    if [ ! -d "$DIRECTORY/$DIR_NOTEBOOK" ]; then
        mkdir $DIRECTORY/$DIR_NOTEBOOK
    else
        echo "Directory $DIRECTORY/$DIR_NOTEBOOK already exists"
    fi
    docker build -t $IMAGE_NAME $DIRECTORY
}

crete_network_if_not_exists() {
    NAME_NETWORK=${1?'Name of network'}
    if [ -n "$(docker network ls -f name=$NAME_NETWORK -q)" ]; then
        echo "Docker is created"
    else
        echo "Docker network is not created"
        docker network create $NAME_NETWORK
        echo "Docker network is created"
    fi
}

start_jupyter() {
    IMAGE_NAME=${1?'Name of image'}
    DIRECTORY=${2:-'jupyter-local'}
    PORT=${3:-'8090'}
    NAME_NETWORK=${4:-'local-instance'}

    crete_network_if_not_exists $NAME_NETWORK
    docker run \
        -d \
        --network $NAME_NETWORK \
        -p 8090:8888 \
        -e GRANT_SUDO=yes \
        --user root \
        -v $PWD/:/home/jovyan/work \
        $IMAGE_NAME \
        start.sh jupyter lab

}

stop_jupyter() {
    IMAGE_NAME=${1?'Name of image'}
    docker rm -f $(docker ps -a -q --filter ancestor=$IMAGE_NAME)
}

start_minio() {
    NAME_NETWORK=${1:-'local-instance'}

    crete_network_if_not_exists $NAME_NETWORK
    docker run \
        -d \
        --network $NAME_NETWORK \
        --name minio \
        -p 9001:9001 \
        -p 9000:9000 \
        -e MINIO_ROOT_USER=minioadmin \
        -e MINIO_ROOT_PASSWORD=minioadmin@123 \
        -v $PWD/data:/data \
        -v $PWD/config:/root/.minio \
        minio/minio server /data --console-address ":9001"
}

stop_minio() {
    docker rm -f $(docker ps -a -q --filter ancestor=minio/minio)
}

"$@"
exit
