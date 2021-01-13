FROM alpine

LABEL maintainer="jcueille@student.42.fr"

WORKDIR /tmp
EXPOSE 8086

RUN apk update
RUN apk add influxdb supervisor
RUN apk add openrc --no-cache
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache

RUN mkdir /etc/telegraf
COPY telegraf.conf /etc/telegraf.conf
COPY entrypoint.sh /tmp
RUN mkdir /var/log/supervisord
RUN mkdir /etc/influxdb
RUN chmod +x entrypoint.sh
#COPY influxdb.conf /etc/influxdb/influxdb.conf
COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT ./entrypoint.sh

