#!/bin/bash

ENVS_FPATH="./envs.sh"
source "$ENVS_FPATH"

start () {
    mkdir -p $HOST_SAVIME_DIR
    if [ $? -ne 0 ]; then
        echo "Could not create the dir $HOST_SAVIME_DIR: the directory already exists. I'm proceeding. Please check if you own and have read/write/run permission over this directory." 
    fi
    mv /tmp/savime-socket  /tmp/savime-socket-bkp  > /dev/null 2>&1
    docker run --rm -p 65000:65000 -v "$HOST_SAVIME_DIR":/dev/shm/savime -v /tmp:/tmp -u $(id -u ${USER}):$(id -g ${USER}) --name savime_container -d savime > /dev/null 2>&1 
    if [ $? -eq  0 ]; then
        echo "Savime container started succesfully."
    fi
}

stop () {
    docker container stop savime_container > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Savime container stopped successfully."
    fi
}

if [[ $1 = "start" ]]; then
    start
elif [[ $1 = "stop" ]]; then
    stop
else
    echo "Usage: $0 <start|stop>"
fi