#!/bin/sh

[ -z "$FTPS_USER" ] && FTPS_USER=admin
[ -z "$FTPS_PASS" ] && FTPS_PASS=password

adduser -D "$FTPS_USER" -h /mnt/vsftpd
mkdir -p /mnt/vsftpd/Test
touch /mnt/vsftpd/Test/test.txt
echo "Bonne correction !" >> /mnt/vsftpd/Test/test.txt
echo "$FTPS_USER:$FTPS_PASS" | chpasswd
supervisord -c /etc/supervisord.conf
