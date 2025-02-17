#!/usr/bin/env sh
cp /home/$USER/gcopd_modeling/dockerfiles/base.df /home/$USER/gcopd_modeling/Dockerfile
if [ -z "$DOCKER_USER"]
then
    echo "Type your Docker Hub username, followed by [ENTER]:"
    read DOCKER_USER
    export DOCKER_USER
fi
docker build -t $DOCKER_USER/gcopd_modeling:base /home/$USER/gcopd_modeling/

rm /home/$USER/gcopd_modeling/Dockerfile
