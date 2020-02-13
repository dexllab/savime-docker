docker build -t savime --network=host --build-arg USER_ID=$(id -u)  --build-arg GROUP_ID=$(id -g) --build-arg NUM_THREADS_MAKE=4 .
