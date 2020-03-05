export NUM_THREADS_MAKE=4
docker build --no-cache -t savime --network=host --build-arg USER_ID=$(id -u)  --build-arg GROUP_ID=$(id -g) --build-arg NUM_THREADS_MAKE="$NUM_THREADS_MAKE" --build-arg USERNAME="$USER" .
