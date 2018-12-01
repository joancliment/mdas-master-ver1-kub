#!/bin/bash
set -e #stops at exception
image=${REGISTRY}/votingapp:${TAG}
app="votingapp"

docker-compose down
docker-compose up -d --build
docker-compose run --rm votingapp-test
docker-compose push votingapp

set +e
kubectl run database --image redis
kubectl expose deployment database --port 6379
kubectl run $app --image $image --env="REDIS=database:6379"
kubectl expose deployment $app --port 80 --type LoadBalancer

set -e
kubectl set image deployment/$app votingapp=$image
kubectl scale --replicas=3 deployment/$app