#!/usr/bin/env sh
if [ -z "$DOCKER_USER"]
then
    echo "Type your Docker Hub username, followed by [ENTER]:"
    read DOCKER_USER
fi
docker run --rm -d --name base -v /home/$USER/gcopd_modeling:/basedir $DOCKER_USER/gcopd_modeling:base
