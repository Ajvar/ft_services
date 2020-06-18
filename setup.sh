#!/bin/sh

if ! which docker >/dev/null 2>&1 ||
    ! which minikube >/dev/null 2>&1
then
    echo "Please install Docker and Minikube"
    exit 1
fi

if ! minikube status >/dev/null 2>&1
then
    if ! minikube start
        then
            echo "Minikube can't start"
            exit 1
        fi
minikube addons enable ingress
fi
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
#kubectl apply -f srcs/dashboard-admin-user.yaml
#kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') | grep "token:" |cut -d " " -f 7 > srcs/token
eval $(minikube docker-env)
docker build -t 42nginx:v1 srcs/nginx/
docker build -t 42ftps:v1 srcs/ftps/
kubectl apply -f nginx.yaml
kubectl apply -f ingress.yaml
kubectl apply -f ftps.yaml

minikube dashboard