#!/bin/bash
set -e 

docker-compose down
docker-compose up -d --build 
docker-compose run --rm votingapp-test
docker-compose push votingapp
