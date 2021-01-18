#!/usr/bin/env zsh

#sudo kubectl delete --all deployment svc pods statefulset pvc pv 1>&2

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
	sudo  apt-get install -y conntrack
fi
# ----- STARTING MINIKUBE ----- #
printf "${green}----- STARTING MINIKUBE -----${eoc}\n"
printf "${green}----- CHECK DOCKER -----${eoc}\n"
if ! which docker >/dev/null 2>&1; then
	./docker_install.sh
fi
printf "${green}----- START DOCKER SVC -----${eoc}\n"
if systemctl status nginx | grep 'inactive (dead)' >/dev/null; then
    systemctl start docker
fi
printf "${green}----- CHECK MINIKUBE -----${eoc}\n"
if ! which minikube >/dev/null 2>&1; then
	./kube_install.sh
fi

if ! minikube status >/dev/null 2>&1; then
	printf "${green}----- STOP NGINX -----${eoc}\n"
	if systemctl status nginx | grep 'active (running)' >/dev/null; then
        service nginx stop
    fi
    printf "${green}----- START KUBE -----${eoc}\n"
# When using the none driver root is needed, since minikube runs the kubernetes system components directly on your machine.
    if !  sudo minikube start --driver=none; then
            echo "Minikube can't start"
            exit 1
        fi
fi
printf "${green}----- CHOWN -----${eoc}\n"
sudo mv /home/user42/.kube /home/user42/.minikube $HOME
sudo chown -R $USER $HOME/.kube $HOME/.minikube
printf "${green}OK${eoc}\n"

# ----- INSTALLING METALLB ----- #
printf "${green}----- INSTALLING METAL LB -----${eoc}\n"
# see what changes would be made, returns nonzero returncode if different
 sudo kubectl get configmap kube-proxy -n kube-system -o yaml | \
 sed -e "s/strictARP: false/strictARP: true/" | \
 sudo kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
sudo kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
sudo kubectl apply -f - -n kube-system
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
sudo kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
sudo kubectl delete -f ./srcs/yamls/metallb-configmap.yaml;sudo kubectl apply -f srcs/yamls/metallb-configmap.yaml

DB_NAME=wordpress; DB_USER=user; DB_PASSWORD=password; DB_HOST=mysql;
kubectl create secret generic db-id \
	--from-literal=name=${DB_NAME} \
	--from-literal=user=${DB_USER} \
	--from-literal=password=${DB_PASSWORD} \
	--from-literal=host=${DB_HOST}

kubectl create secret generic influxdb-creds \
  --from-literal=INFLUXDB_DATABASE=telegraf-db \
  --from-literal=INFLUXDB_USERNAME=${DB_USER} \
  --from-literal=INFLUXDB_PASSWORD=${DB_PASSWORD} \
  --from-literal=INFLUXDB_HOST=influxdb

IP=$( sudo kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "${green}----- BUILD IMAGES -----${eoc}\n"
docker build -t 42influxdb srcs/influxdb
docker build -t 42phpmyadmin --build-arg IP=${IP} srcs/phpmyadmin
docker build -t 42wordpress --build-arg IP=${IP} srcs/wordpress
docker build -t 42ftps srcs/ftps
docker build -t 42mysql --build-arg IP=${IP} srcs/mysql
docker build -t 42grafana srcs/grafana

WPIP=$( sudo kubectl get svc wordpress | cut -d " " -f 10 )
PHPIP=$( sudo kubectl get svc phpmyadmin | cut -d " " -f 10 | cut -d $'\n' -f2)
sudo kubectl apply -f srcs/yamls/volume.yaml
sudo kubectl apply -f srcs/yamls/influxdb.yaml
sudo kubectl apply -f srcs/yamls/mysql.yaml
sudo kubectl apply -f srcs/yamls/phpmyadmin.yaml
sudo kubectl apply -f srcs/yamls/wordpress.yaml
docker build -t 42nginx --build-arg WPIP=${WPIP} --build-arg PHPIP=${PHPIP} srcs/nginx
sudo kubectl apply -f srcs/yamls/ftps.yaml
sudo kubectl apply -f srcs/yamls/nginx.yaml
sudo kubectl apply -f srcs/yamls/grafana.yaml


sudo minikube dashboard &

