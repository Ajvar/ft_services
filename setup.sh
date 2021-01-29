#!/usr/bin/env zsh

green="\e[1;92m"
eoc="\e[0m"

printf "${green}----- CHECKING DEPENDENCIES -----${eoc}\n"
#Checks if running on Linux
if [[ "$OSTYPE" != "linux-gnu" ]]; then
	echo "only works on linux OS.\nExiting."
	exit 1
fi
#Checks if user present on docker group
if ! groups | grep "docker" >/dev/null 1>&2; then
	echo "Please do : sudo usermod -aG docker user42; newgrp docker"
	exit 1
fi

#Checks if conntrack is installed
if ! which conntrack >/dev/null 1>&2; then
	sudo  apt-get install -y conntrack
fi
#Checks if docker is installed, installs it if necessary
if ! which docker >/dev/null 2>&1; then
	./docker_install.sh
fi
#Checks if Minikube is installed, installs it if necessary
if ! which minikube >/dev/null 2>&1; then
	./kube_install.sh
fi
# ----- STARTING MINIKUBE ----- #
printf "${green}----- STARTING MINIKUBE -----${eoc}\n"
# When using the none driver root is needed, since minikube runs the kubernetes system components directly on your machine.
if !  sudo minikube start --driver=none; then
    echo "Minikube can't start"
    exit 1
fi

sudo mv /home/user42/.kube /home/user42/.minikube $HOME
sudo chown -R $USER $HOME/.kube $HOME/.minikube
printf "${green}MINIKUBE LAUNCHED :)${eoc}\n"

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

export EXTERNAL_IP=`minikube ip`
sudo rm -rf srcs/yamls/modified-yamls/*.yaml
envsubst '$EXTERNAL_IP' < srcs/yamls/nginx.yaml					> srcs/yamls/modified-yamls/nginx.yaml
envsubst '$EXTERNAL_IP' < srcs/yamls/phpmyadmin.yaml			> srcs/yamls/modified-yamls/phpmyadmin.yaml
envsubst '$EXTERNAL_IP' < srcs/yamls/wordpress.yaml				> srcs/yamls/modified-yamls/wordpress.yaml
envsubst '$EXTERNAL_IP' < srcs/yamls/metallb-configmap.yaml		> srcs/yamls/modified-yamls/metallb-configmap.yaml
envsubst '$EXTERNAL_IP' < srcs/yamls/ftps.yaml					> srcs/yamls/modified-yamls/ftps.yaml
envsubst '$EXTERNAL_IP' < srcs/yamls/grafana.yaml				> srcs/yamls/modified-yamls/grafana.yaml
printf "${green}----- BUILD IMAGES -----${eoc}\n"

docker build -t 42influxdb srcs/influxdb
docker build -t 42mysql srcs/mysql
docker build -t 42phpmyadmin srcs/phpmyadmin
docker build -t 42wordpress srcs/wordpress
docker build -t 42nginx srcs/nginx
docker build -t 42ftps srcs/ftps
docker build -t 42grafana srcs/grafana

sudo kubectl delete -f srcs/yamls/modified-yamls/metallb-configmap.yaml;sudo kubectl apply -f srcs/yamls/modified-yamls/metallb-configmap.yaml
sudo kubectl apply -f srcs/yamls/volume.yaml
sudo kubectl apply -f srcs/yamls/influxdb.yaml
sudo kubectl apply -f srcs/yamls/mysql.yaml
sudo kubectl apply -f srcs/yamls/modified-yamls/phpmyadmin.yaml
sudo kubectl apply -f srcs/yamls/modified-yamls/wordpress.yaml
sudo kubectl apply -f srcs/yamls/modified-yamls/ftps.yaml
sudo kubectl apply -f srcs/yamls/modified-yamls/nginx.yaml
sudo kubectl apply -f srcs/yamls/modified-yamls/grafana.yaml

sudo minikube dashboard &

