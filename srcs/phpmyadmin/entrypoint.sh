#!/bin/sh

# sed s/__DB_USER__/$DB_USER/g /var/www/phpmyadmin/config.inc.php -i
# sed s/__DB_PASSWORD__/$DB_PASSWORD/g /var/www/phpmyadmin/config.inc.php -i
#sed s/__DB_HOST__/$DB_HOST/g /var/www/phpmyadmin/config.inc.php -i
sed s/localhost/$DB_HOST/g /var/www/phpmyadmin/config.sample.inc.php > /var/www/phpmyadmin/config.inc.php
echo "\$cfg['PmaAbsoluteUri'] = './';" >> /var/www/phpmyadmin/config.inc.php
mkdir -p /etc/telegraf
telegraf -sample-config --input-filter cpu:mem:net:swap:diskio --output-filter influxdb > /etc/telegraf/telegraf.conf
sed -i s/'# urls = \["http:\/\/127.0.0.1:8086"\]'/'urls = ["http:\/\/influxdb:8086"]'/ /etc/telegraf/telegraf.conf
sed -i s/'# database = "telegraf"'/'database = "phpmyadmin-db"'/ /etc/telegraf/telegraf.conf
sed -i s/'omit_hostname = false'/'omit_hostname = true'/ /etc/telegraf/telegraf.conf
supervisord
