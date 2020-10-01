#!/usr/bin/env zsh

kubectl delete --all deployment svc pods statefulset pvc pv secret 1>&2
rm -rf /tmp/k8s_pvc 1>&2

red="\e[1;91m"
green="\e[1;92m"
yellow="\e[1;93m"
dblue="\e[1;94m"
purple="\e[1;95m"
blue="\e[1;96m"
eoc="\e[0m"
underlined="\e[4m"
if [[ "$OSTYPE" != "linux-gnu" ]]; then
	echo "only works on linux OS.\nExiting."
	exit 1
fi
if ! groups | grep "docker" >/dev/null 1>&2; then
	echo "Please do : sudo usermod -aG docker user42; newgrp docker"
	exit 1
fi
if ! which conntrack >/dev/null 1>&2; then
	sudo apt-get install conntrack
fi
# ----- STARTING MINIKUBE ----- #
printf "${green}----- STARTING MINIKUBE -----${eoc}\n"
if ! which docker >/dev/null 2>&1; then
	./docker_install.sh
fi
if ! which minikube >/dev/null 2>&1; then
	./kube_install.sh
fi

if ! minikube status >/dev/null 2>&1; then
	service nginx stop
    if ! sudo minikube start --driver=none; then
            echo "Minikube can't start"
            exit 1
        fi
fi
sudo chown -R user42 $HOME/.kube $HOME/.minikube
printf "${green}OK${eoc}\n"
# ----- INSTALLING METALLB ----- #
printf "${green}----- INSTALLING METAL LB -----${eoc}\n"
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl delete -f ./srcs/metallb-configmap.yaml;kubectl apply -f srcs/metallb-configmap.yaml

#eval $(minikube docker-env)
docker build srcs/nginx -t 42nginx 
docker build -t 42ftps srcs/ftps/
kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/ftps.yaml

sudo minikube dashboard &
