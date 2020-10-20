FROM alpine:3.12.0

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 3306

RUN apk update
RUN apk add --no-cache  mysql mysql-client supervisor
RUN mkdir -p /var/log/supervisord
COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /etc/supervisord.conf
COPY wp-init.sh /wp-init.sh
RUN mkdir -p /run/openrc
RUN touch /run/openrc/softlevel
RUN apk add openrc
RUN rc-service mariadb setup
ENTRYPOINT ./entrypoint.sh

