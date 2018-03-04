#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/home/$USER/.Xauthority
SHARED_DIR=/home/$USER/shared_dir
HOST_DIR=/home/$USER/shared_dir

<<<<<<< HEAD
if [ "$1" = "kinetic" ] || [ "$1" = "indigo" ]
then
    echo "Use $1"
else
    echo "Select distribution, kinetic|indigo"
=======
if [ "$1" = "kinetic" ] || [ "$1" = "indigo" ] || [ "$1" = "test" ]
then
    echo "Using $1"
else
    echo "Select distribution, kinetic|indigo|test"
>>>>>>> 5629c4a3df90b6a28326086050a81bd8a79fe1d6
    exit
fi

if [ "$2" = "" ]
then
    # Create Shared Folder
    mkdir -p $SHARED_DIR
else
    HOST_DIR=$2
fi
echo "Shared directory: ${HOST_DIR}"

nvidia-docker run \
    -it --rm \
    --volume=$XSOCK:$XSOCK:rw \
    --volume=$XAUTH:$XAUTH:rw \
    --volume=$HOST_DIR:$SHARED_DIR:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
<<<<<<< HEAD
    -u autoware \
    --privileged -v /dev/bus/usb:/dev/bus/usb \
    --net=host \
    autoware-$1
=======
    --privileged -v /dev/bus/usb:/dev/bus/usb \
    --net=host \
autoware-$1


#     -u autoware \
>>>>>>> 5629c4a3df90b6a28326086050a81bd8a79fe1d6
