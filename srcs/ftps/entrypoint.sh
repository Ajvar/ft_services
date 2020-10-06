#!/bin/sh

[ -z "$FTPS_USER" ] && FTPS_USER=admin
[ -z "$FTPS_PASS" ] && FTPS_PASS=password

adduser -D "$FTPS_USER"

echo "$FTPS_USER:$FTPS_PASS" | chpasswd
supervisord -c /etc/supervisord.conf
