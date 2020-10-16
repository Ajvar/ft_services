#!/bin/sh

IP=$(cat /ip.txt)
sed -iun "s/AAAIPAAA/$IP/g" /usr/share/webapps/wordpress/wp-config.php

supervisord
