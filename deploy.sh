#!/bin/bash

echo Building images
docker build -t bitofant/multi-client:latest -t bitofant/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t bitofant/multi-server:latest -t bitofant/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t bitofant/multi-worker:latest -t bitofant/multi-worker:$SHA -f ./worker/Dockerfile ./worker

echo Pushing images to hub.docker.com
docker push bitofant/multi-client:latest
docker push bitofant/multi-server:latest
docker push bitofant/multi-worker:latest
docker push bitofant/multi-client:$SHA
docker push bitofant/multi-server:$SHA
docker push bitofant/multi-worker:$SHA

echo Applying kubernetes changes
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=bitofant/multi-server:$SHA
kubectl set image deployments/client-deployment client=bitofant/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=bitofant/multi-worker:$SHA
