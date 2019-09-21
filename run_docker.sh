#!/usr/bin/env sh
echo "Type your Docker Hub username, followed by [ENTER]:"
read DOCKER_USER
docker run --rm -d --name base $DOCKER_USER/gcopd_modeling:base
