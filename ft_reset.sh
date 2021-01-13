#!/bin/bash

sudo kubectl delete statefulset $1
sudo kubectl delete svc $1
sudo kubectl delete pvc $1-pvc
sudo kubectl delete pod $1-0
sudo kubectl delete pod $1-1
sudo kubectl apply -f srcs/yamls/$1.yaml

