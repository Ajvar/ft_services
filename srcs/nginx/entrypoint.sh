#!/usr/bin/env sh

export user=username;
export user_pass=;


sed 's/___WP_SVC_IP___/$WPIP/' /etc/nginx/nginx.conf
sed 's/___PHP_SVC_IP___/$PHPIP' /etc/nginx/nginx.conf
adduser -D ${user};
echo "$user:$user_pass" | chpasswd
ssh-keygen -A
supervisord -c /etc/supervisord.conf
tail -f /dev/null
