#!/usr/bin/env sh

export user=username;
export user_pass=;


sed -i "s/___WP_SVC_IP___/$(cat wpip.txt)/" /etc/nginx/nginx.conf
sed -i "s/___PHP_SVC_IP___/$(cat phpip.txt)/" /etc/nginx/nginx.conf
adduser -D ${user};
echo "$user:$user_pass" | chpasswd
ssh-keygen -A
supervisord -c /etc/supervisord.conf
tail -f /dev/null
