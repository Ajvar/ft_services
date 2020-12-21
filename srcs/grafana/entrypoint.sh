#!/bin/sh

sed -i "s/AAAIPAAA/$(env | grep INFLUXDB_SERVICE_HOST | cut -c 23-)/" /usr/share/grafana/conf/provisioning/datasources/influxdb-datasource.yaml
