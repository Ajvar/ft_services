[ -z $FTPS_USER ] && FTPS_USER=admin
[ -z $FTPS_PASS ] && FTPS_PASS=password

adduser -D admin

echo "$FTPS_USER:$FTPS_PASS" | chpasswd
Minikube_ip=`minikube ip`

/usr/local/sbin/pure-ftpd -Y 2 -P $Minikube_ip