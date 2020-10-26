#! /bin/bash

# Wait that mysql was up
#until mysql
#do
#	echo "NO_UP"
#done

# Init DB
echo "CREATE DATABASE IF NOT EXISTS wordpress;" | mysql -u root --skip-password
echo "CREATE USER IF NOT EXISTS 'user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'user'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
mysql wordpress -u root --password=  < wordpress.sql
