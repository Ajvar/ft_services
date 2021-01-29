#!/bin/sh
sed -i s/"domain = localhost"/"domain = ${IP}"/g /usr/share/grafana/conf/custom.ini
supervisord
