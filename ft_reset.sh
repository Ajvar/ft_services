#!/bin/bash

pod=$(sudo kubectl get po | grep $1 | cut -d " " -f 1)
sudo kubectl delete statefulset $1
sudo kubectl delete deploy $1
sudo kubectl delete svc $1
sudo kubectl delete pvc $1-pvc
sudo kubectl delete pod $pod
sudo kubectl apply -f srcs/yamls/modified-yamls/$1.yaml

