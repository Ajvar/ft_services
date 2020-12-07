#!/bin/bash

sudo kubectl delete statefulset $1
sudo kubectl delete svc $1
sudo kubectl delete pvc $1
sudo kubectl delete pod $1-0
sudo kubectl apply -f srcs/$1.yaml

