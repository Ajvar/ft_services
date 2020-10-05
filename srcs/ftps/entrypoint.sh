#!/bin/sh

[ -z "$FTPS_USER" ] && FTPS_USER=admin
[ -z "$FTPS_PASS" ] && FTPS_PASS=password

adduser -D "$FTPS_USER"

echo "$FTPS_USER:$FTPS_PASS" | chpasswd
#Minikube_ip=`minikube ip`

#/usr/sbin/pure-ftpd -Y 2 #-P $Minikube_ip
supervisord -c /etc/supervisord.conf
#sh
