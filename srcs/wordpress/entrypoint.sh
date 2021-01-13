#!/bin/sh

IP=$(hostname -i)
#$(cat IP.txt)
sed -iun "s/AAAIPAAA/$IP/g" /usr/share/webapps/wordpress/wp-config.php
#/usr/sbin/nginx -g 'daemon off;'
supervisord
