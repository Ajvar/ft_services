FROM alpine

LABEL maintainer="jcueille@student.42.fr"

WORKDIR /tmp
ARG IP
EXPOSE 3000
RUN apk update
RUN apk add supervisor
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/community --no-cache
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache
RUN mkdir /etc/telegraf
COPY telegraf.conf /etc/telegraf.conf
COPY entrypoint.sh /tmp
COPY supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisord
RUN touch IP.txt
COPY config.ini /usr/share/grafana/conf/custom.ini
COPY ./influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY ./dashboard.yaml /usr/share/grafana/conf/provisioning/dashboards/
COPY ./dashboards /var/lib/grafana/dashboards/
RUN mkdir -p /var/log/supervisor/
RUN chmod +x entrypoint.sh
ENTRYPOINT ./entrypoint.sh

