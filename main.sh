#!/bin/bash

#  _____                                           _   _          _____ _             _                     _   _____ _                _____                 _
# /  __ \                                         | | | |        /  ___| |           | |                   | | /  ___| |              /  ___|               (_)
# | /  \/ ___  _ __ ___  _ __ ___   __ _ _ __   __| | | |_ ___   \ `--.| |_ __ _ _ __| |_    __ _ _ __   __| | \ `--.| |_ ___  _ __   \ `--.  ___ _ ____   ___  ___ ___  ___
# | |    / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` | | __/ _ \   `--. \ __/ _` | '__| __|  / _` | '_ \ / _` |  `--. \ __/ _ \| '_ \   `--. \/ _ \ '__\ \ / / |/ __/ _ \/ __|
# | \__/\ (_) | | | | | | | | | | | (_| | | | | (_| | | || (_) | /\__/ / || (_| | |  | |_  | (_| | | | | (_| | /\__/ / || (_) | |_) | /\__/ /  __/ |   \ V /| | (_|  __/\__ \
#  \____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|  \__\___/  \____/ \__\__,_|_|   \__|  \__,_|_| |_|\__,_| \____/ \__\___/| .__/  \____/ \___|_|    \_/ |_|\___\___||___/
#                                                                                                                             | |
#                                                                                                                             |_|

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

    if [ $SERVICE = "jupyter" ]; then
        echo "Creating jupyter service"
        mkdir -p $SERVICE/notebooks
        touch poetry.lock
        touch pyproject.toml
    elif [ $SERVICE = "airflow" ]; then
        echo "Creating airflow service"
        export AIRFLOW_UID=50000
        docker compose --project-directory ./$SERVICE up airflow-init
    fi

    docker compose --project-directory ./$SERVICE build
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
