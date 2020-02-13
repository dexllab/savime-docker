FROM ubuntu:18.04

ARG USER_ID
ARG GROUP_ID
ARG NUM_THREADS_MAKE

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y git
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y libtbb-dev
RUN apt-get install -y bison
RUN apt-get install -y flex
RUN apt-get install -y librdmacm-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libjsoncpp-dev
RUN apt-get install -y cmake


RUN git clone https://github.com/hllustosa/Savime.git savime-src
WORKDIR $pwd/savime-src/release
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/home/user/savime ../ 
RUN make -j $NUM_THREADS_MAKE && make install
RUN cd ../../
RUN rm -rf savime-src

USER user
WORKDIR /home/user/

EXPOSE 65000
ENV SHM_STORAGE_DIR="/dev/shm/savime"
ENV SEC_STORAGE_DIR="/dev/shm/savime"
ENV MAX_THREADS=1
RUN printf "mkdir -p \$SHM_STORAGE_DIR\n" > run.sh
RUN printf "mkdir -p \$SEC_STORAGE_DIR\n" >> run.sh
RUN printf "export PATH=\$PATH:/home/user/savime/bin\n" >> run.sh
RUN printf "echo \$PATH\n" >> run.sh
RUN printf "savime -m \$MAX_THREADS -s \$SHM_STORAGE_DIR -d \$SEC_STORAGE_DIR\n" >> run.sh
CMD ["sh", "run.sh"]