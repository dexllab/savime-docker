# Docker Image for SAVIME

This repository contains the necessary artifacts for instantiating [SAVIME](https://github.com/hllustosa/Savime) as a docker container. The first step you need to take is building a docker image for SAVIME, which requires you have already installed the docker suite. If you have not done that yet, please follow the instructions posted on the [docker install page](https://docs.docker.com/install/). However, if your operating system is [Ubuntu](https://ubuntu.com/), you'd better follow this [Digital Ocean tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04) which is easier and more comprehensive than the one posted on the docker site.

To build the docker image, run the [build.sh](build.sh) script in this directory. It will build an image named `savime` based on this [docker file](Dockerfile). If this process ran accordingly, you should be able to see the recently built image listed in the `docker image` command results. 

The second step is image instantiation, i.e., launch a container. To alleviate the configuration burden, you should resort to the [run.sh](run.sh) script. But first, take a look at [envs.sh](envs.sh) as you may want to configure the environment variables displayed in this file:

- MAX_THREADS: The maximum number of threads SAVIME should use.
- HOST_SAVIME_PORT: The port where SAVIME is to listen in the host.
- HOST_SAVIME_DIR: The SAVIME shm storage dir (host).

Finally, run `./run.sh start` to start a container named `savime_container` and `./run.sh stop` to stop it.
To assure that the container is running accordingly: 
- Check whether there exists a file named `savime_socket` in the `/tmp` dir. Your user must be the owner of this file and have read/write/run permissions over it.
- Check also whether your user is the owner of the directory `$HOST_SAVIME_DIR` and have read/write/run permissions over it.
- Run the savime client (`savimec`).

Ps.: To avoid permission problems, the building procedure assigns the host user and group --- which ran the script `build.sh` --- to the `savime` image by resorting to the Linux command `id`.