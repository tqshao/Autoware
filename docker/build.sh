#!/bin/sh

# Build Docker Image
<<<<<<< HEAD
if [ "$1" = "kinetic" ] || [ "$1" = "indigo" ]
=======
if [ "$1" = "kinetic" ] || [ "$1" = "indigo" ] || [ "$1" = "test" ]
>>>>>>> 5629c4a3df90b6a28326086050a81bd8a79fe1d6
then
    echo "Use $1"
    nvidia-docker build -t autoware-$1 -f Dockerfile.$1 .
else
    echo "Select distribution, kinetic|indigo"
fi
