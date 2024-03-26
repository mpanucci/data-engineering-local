#!/bin/bash

build_image() {
    IMAGE_NAME=${1?'Name of image'}
    DIRECTORY=${2?'Directory of image'}
    
    if [  $DIRECTORY="jupyter" ]; then
        mkdir -p $DIRECTORY/notebooks
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

start_service() {
    SERVICE=${1?'Name of service'}
    IMAGE_NAME=${2:- ''}
    NAME_NETWORK=${3:-'local-instance'}

    export IMAGE_NAME=$IMAGE_NAME
    export NAME_NETWORK=$NAME_NETWORK
    crete_network_if_not_exists $NAME_NETWORK
    mkdir -p ./$SERVICE/data
    docker compose --project-directory ./$SERVICE up -d
}


stop_service() {
    SERVICE=${1?'Name of service'}
    IMAGE_NAME=${2:- ''}
    NAME_NETWORK=${3:-'local-instance'}

    export IMAGE_NAME=$IMAGE_NAME
    export NAME_NETWORK=$NAME_NETWORK
    docker compose --project-directory ./$SERVICE down
}


"$@"
exit
