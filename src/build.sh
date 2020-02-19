#!/usr/bin/env bash
docker build -t otsdaq-cvmfs --build-arg MYUID=$UID --build-arg MYGID=$(id -g) --build-arg USER=$USER .
