#!/bin/sh

#./wp-init.sh
#rmdir /val/lib/mysql
echo "mysql_install_db --datadir=/var/lib/mysql"
mysql_install_db --datadir=/var/lib/mysql
sleep 5
echo '/usr/bin/mysqld_safe --datadir="/var/lib/mysql"'
/usr/bin/mysqld_safe --no-watch --datadir="/var/lib/mysql" &
sleep 5
#mysqld --default-authentication-plugin=mysql_native_password &
echo "/etc/init.d/mariadb"
#/etc/init.d/mariadb start
#supervisord
