FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y git
RUN git clone https://github.com/hllustosa/Savime.git

RUN apt-get install -y libboost-all-dev && \
    apt-get install -y libtbb-dev && \
    apt-get install -y bison && \
    apt-get install -y flex && \
    apt-get install -y librdmacm-dev && \
    apt-get install -y libcurl4-openssl-dev && \
    apt-get install -y libjsoncpp-dev && \
    apt-get install -y cmake && \
    apt-get clean

WORKDIR ${pwd}/Savime/release
RUN cmake -DCMAKE_BUILD_TYPE=Release BUILD_WITH_FULL_TYPE_SUPPORT --target  ../ && \
    make -j 4 && \ 
    make install

WORKDIR /root
RUN rm -rf Savime

EXPOSE 65000
ENV SHM_STORAGE_DIR="/dev/shm/savime"
ENV SEC_STORAGE_DIR="/dev/shm/savime"
ENV MAX_THREADS=1
RUN printf "savime -D -m \$MAX_THREADS -s \$SHM_STORAGE_DIR -d \$SEC_STORAGE_DIR\n" >> run.sh
RUN printf "chmod 0777 /tmp/savime-socket\nchmod -R 0666 \$SHM_STORAGE_DIR\nchmod -R 0666 \$SEC_STORAGE_DIR\n" >> run.sh
RUN printf "while true; do echo > /dev/null; done;\n" >> run.sh
CMD ["sh", "run.sh"]
