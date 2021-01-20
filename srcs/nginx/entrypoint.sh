#!/usr/bin/env sh

export user=username;
export user_pass=;

sed -i s/__EXTERNAL_IP__/$IP/g /etc/nginx/conf.d/default.conf
adduser -D ${user};
echo "$user:$user_pass" | chpasswd
ssh-keygen -A
supervisord -c /etc/supervisord.conf
tail -f /dev/null
