# Docker Image for SAVIME

This repository contains the necessary artifacts for instantiating [SAVIME](https://github.com/hllustosa/Savime) as a docker container. The first step you need to take is building a docker image for SAVIME, which requires you have already installed the docker suite. If you have not done that yet, please follow the instructions posted on the [docker install page] (https://docs.docker.com/install/). However, if your operating system is [Ubuntu](https://ubuntu.com/), you'd better follow this [Digital Ocean tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04) which is easier and more comprehensive than the one posted on the docker site.

To build the docker image run the [build.sh](build.sh) script in this directory. It will build an image named **savime** based on this [docker file](Dockerfile). If the process ran accordingly, you should be able to see the recently built image listed in the docker image command results. 

The second step is image instantiation. To alleviate the configuration burden you should resort to the [run.sh](run.sh) script. But first, you have to configure some environment variables in [envs.sh](envs.sh):

- SHM_STORAGE_DIR: The SAVIME shm storage dir (guest).
- SEC_STORAGE_DIR: The SAVIME secondary storage dir (guest).
- MAX_THREADS: The maximum number of threads SAVIME should use.
- HOST_SAVIME_PORT: The port where SAVIME is to listen in the host.
- HOST_SHM_STORAGE_DIR: The SAVIME shm storage dir (host).
- HOST_SEC_STORAGE_DIR: The SAVIME secondary storage dir (host).
- DETACH_CONTAINER_FROM_TERMINAL: Whether or not the container should be detached from the terminal.