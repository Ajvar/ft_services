#!/bin/sh

sed -i s/__EXTERNAL_IP__/$IP/g /etc/vsftpd/vsftpd.conf

[ -z "$FTPS_USER" ] && FTPS_USER=user
[ -z "$FTPS_PASS" ] && FTPS_PASS=password

adduser -D "$FTPS_USER" -h /mnt/ftp
echo "$FTPS_USER:$FTPS_PASS" | chpasswd
if [ ! -f /home/ftps/hello ]; then
	echo "hello world!" > /mnt/ftp/hello
	mkdir -p /mnt/ftp/jcueille
	echo "Coucou!" > /mnt/ftp/jcueille/jcueillefile
fi
supervisord -c /etc/supervisord.conf
