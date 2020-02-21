#!/bin/bash
mkdir -p data db
docker-compose up -d && docker container attach ots
