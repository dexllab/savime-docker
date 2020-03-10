#!/bin/bash

ENVS_FPATH="./envs.sh"
source "$ENVS_FPATH"
export SOCKET_BACKUP_NAME=savime_socket_"$(uptime -s | sed 's/[ |:|-]/_/g')"

start () {
    mkdir -p $HOST_SAVIME_DIR > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Could not create the dir $HOST_SAVIME_DIR: the directory already exists. I'm proceeding. Please check if you own and have read/write/run permission over this directory." 
    fi
    
    test -e /tmp/savime-socket 
    if [ $? -eq 0 ]; then
        mv /tmp/savime-socket /tmp/"$SOCKET_BACKUP_NAME" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Check the permissions on the file /tmp/savime-socket; it looks like you do not have permission over it. Exiting."
            exit 1
        fi
    fi
    
    docker run -dit -p "$HOST_SAVIME_PORT":65000 -v "$HOST_SAVIME_DIR":/dev/shm/savime -v /tmp:/tmp -u $(id -u ${USER}):$(id -g ${USER}) --name savime_container -e MAX_THREADS=$MAX_THREADS -d savime > /dev/null 2>&1 
    if [ $? -eq  0 ]; then
        echo "Savime container started succesfully."
    else 
        echo "Could not run Savime container. Is the image created?"
    fi
    
    chmod 777 /tmp/savime-socket
}

stop () {
    docker container stop savime_container > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Savime container stopped successfully."
    else
        echo "An error ocurred while trying to stop the container."
        exit 1
    fi
    
    mv /tmp/savime-socket /tmp/"$SOCKET_BACKUP_NAME" > /dev/null 2>&1
}

if [[ $1 = "start" ]]; then
    start
elif [[ $1 = "stop" ]]; then
    stop
else
    echo "Usage: $0 <start|stop>"
fi
