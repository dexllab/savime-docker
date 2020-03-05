FROM ubuntu:18.04

ARG USER_ID
ARG USERNAME
ARG GROUP_ID
ARG NUM_THREADS_MAKE

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID "$USERNAME"

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

WORKDIR /home/"$USERNAME"/
RUN git clone https://github.com/hllustosa/Savime.git savime-src
WORKDIR /home/"$USERNAME"/savime-src/release
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/home/"$USERNAME"/savime --target savime-bin ../
RUN make -j $NUM_THREADS_MAKE && make install
WORKDIR /home/"$USERNAME"/
RUN chown -R "$USERNAME" /home/"$USERNAME"/savime
RUN chgrp -R $(getent group "$GROUP_ID" | cut -d: -f1) /home/"$USERNAME"/savime
WORKDIR /dev/shm/savime 
RUN chown -R "$USERNAME" /dev/shm/savime
RUN chgrp -R $(getent group "$GROUP_ID" | cut -d: -f1) /dev/shm/savime
WORKDIR /home/"$USERNAME"/

EXPOSE 65000
ENV MAX_THREADS=1
ENV USERNAME=$USERNAME

RUN printf "export PATH=\$PATH:/home/\"\$USERNAME\"/savime/bin\n" >> run.sh
RUN printf "savime -m \$MAX_THREADS\n" >> run.sh
CMD ["sh", "run.sh"]
