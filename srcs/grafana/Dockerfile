FROM alpine

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 3000
RUN apk update
RUN apk add supervisor
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/community --no-cache
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache
COPY telegraf.conf /etc/telegraf.conf
COPY entrypoint.sh ./entrypoint.sh
COPY supervisord.conf /etc/supervisord.conf
COPY config.ini /usr/share/grafana/conf/custom.ini
COPY ./influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY ./nginx.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY ./phpmyadmin.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY ./dashboard.yaml /usr/share/grafana/conf/provisioning/dashboards/
COPY ./dashboards /var/lib/grafana/dashboards/
#COPY grafana.db /usr/share/grafana/data/grafana.db
RUN mkdir -p /var/log/supervisor/ /var/log/supervisord
ENTRYPOINT ./entrypoint.sh

