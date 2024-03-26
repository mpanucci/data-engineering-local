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

    export IMAGE_NAME=$IMAGE_NAME
    export NAME_NETWORK=$NAME_NETWORK
    crete_network_if_not_exists $NAME_NETWORK
    docker compose --project-directory ./jupyter-local up -d

}

stop_jupyter() {
    IMAGE_NAME=${1?'Name of image'}
    NAME_NETWORK=${2:-'local-instance'}
    export IMAGE_NAME=$IMAGE_NAME
    export NAME_NETWORK=$NAME_NETWORK
    docker compose --project-directory ./jupyter-local down
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
    docker rm -f $(docker ps -a -q --filter name=minio)
}

start_postgresql() {
    NAME_NETWORK=${1:-'local-instance'}

    crete_network_if_not_exists $NAME_NETWORK
    docker run \
        -d \
        --network $NAME_NETWORK \
        --name local-postgres \
        -p 5432:5432 \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_PASSWORD=postgres@123 \
        -v $PWD/postgresql/data:/var/lib/postgresql/data \
        postgres
}

stop_postgresql() {
    docker rm -f $(docker ps -a -q --filter name=local-postgres)
}

start_mysql() {
    NAME_NETWORK=${1:-'local-instance'}

    crete_network_if_not_exists $NAME_NETWORK
    docker run \
        -d \
        --network $NAME_NETWORK \
        --name local-mysql \
        -p 3306:3306 \
        -e MYSQL_ROOT_PASSWORD=mysql@123 \
        -v $PWD/mysql/data:/var/lib/mysql \
        mysql
}

stop_mysql() {
    docker rm -f $(docker ps -a -q --filter name=local-mysql)
}


start_mongodb() {
    NAME_NETWORK=${1:-'local-instance'}

    crete_network_if_not_exists $NAME_NETWORK
    docker run \
        -d \
        --network $NAME_NETWORK \
        --name local-mongodb \
        -p 27017:27017 \
        -e MONGO_INITDB_ROOT_USERNAME=root \
        -e MONGO_INITDB_ROOT_PASSWORD=mongo@123 \
        -v $PWD/mongodb/data:/data/db \
        mongo
}

stop_mongodb(){
    docker rm -f $(docker ps -a -q --filter name=local-mongodb)
}


"$@"
exit
