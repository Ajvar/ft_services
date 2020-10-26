#!/bin/sh

mysql_install_db --datadir=/var/lib/mysql
/usr/bin/mysqld_safe --no-watch --datadir="/var/lib/mysql" &
sleep 5
./wp-init.sh
supervisord