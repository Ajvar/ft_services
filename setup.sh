#!/usr/bin/env zsh

#kubectl delete --all deployment svc pods statefulset pvc pv secret 1>&2
#rm -rf /tmp/k8s_pvc 1>&2

red="\e[1;91m"
green="\e[1;92m"
yellow="\e[1;93m"
dblue="\e[1;94m"
purple="\e[1;95m"
blue="\e[1;96m"
eoc="\e[0m"
underlined="\e[4m"
printf "${green}----- OS CHECK -----${eoc}\n"
if [[ "$OSTYPE" != "linux-gnu" ]]; then
	echo "only works on linux OS.\nExiting."
	exit 1
fi
printf "${green}----- GROUP CHECK -----${eoc}\n"
if ! groups | grep "docker" >/dev/null 1>&2; then
	echo "Please do : sudo usermod -aG docker user42; newgrp docker"
	exit 1
fi
printf "${green}----- CONNTRACK CHECK -----${eoc}\n"
if ! which conntrack >/dev/null 1>&2; then
	sudo apt-get install conntrack
fi
# ----- STARTING MINIKUBE ----- #
printf "${green}----- STARTING MINIKUBE -----${eoc}\n"
printf "${green}----- CHECK DOCKER -----${eoc}\n"
if ! which docker >/dev/null 2>&1; then
	./docker_install.sh
fi
printf "${green}----- START DOCKER SVC -----${eoc}\n"
if ! pgrep -x docker >/dev/null; then
    systemctl start docker
fi
printf "${green}----- CHECK MINIKUBE -----${eoc}\n"
if ! which minikube >/dev/null 2>&1; then
	./kube_install.sh
fi

if ! minikube status >/dev/null 2>&1; then
	printf "${green}----- STOP NGINX -----${eoc}\n"
	if pgrep -x nginx >/dev/null; then
        service nginx stop
    fi
    printf "${green}----- START KUBE -----${eoc}\n"
    if ! sudo minikube start --driver=none; then
            echo "Minikube can't start"
            exit 1
        fi
fi
printf "${green}----- CHOWN -----${eoc}\n"
#sudo chown -R user42 $HOME/.kube $HOME/.minikube
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
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "${green}----- BUILD IMAGES -----${eoc}\n"
docker build srcs/nginx -t 42nginx 
docker build -t 42ftps srcs/ftps
docker build -t 42wordpress --build-arg IP=${IP} srcs/wordpress
#docker build -t 42mysql --build-arg IP=${IP} srcs/mysql
#docker build -t 42phpmyadmin --build-arg IP=${IP} srcs/phpmyadmin



kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/ftps.yaml

sudo minikube dashboard &
