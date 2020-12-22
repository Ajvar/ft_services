FROM alpine

LABEL maintainer="jcueille@student.42.fr"

WORKDIR /tmp
ARG IP
EXPOSE 8086
RUN apk update
RUN apk add influxdb supervisor
RUN apk add openrc --no-cache
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache

RUN mkdir /etc/telegraf
COPY telegraf.conf /etc/telegraf
COPY entrypoint.sh /tmp
COPY supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisord
RUN touch IP.txt
RUN echo ${IP} > IP.txt
RUN chmod +x entrypoint.sh
ENTRYPOINT ./entrypoint.sh

