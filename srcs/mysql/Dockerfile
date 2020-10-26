FROM alpine

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 3306

RUN apk update
RUN apk add mysql mysql-client supervisor openrc --no-cache
RUN mkdir -p /var/log/supervisord /run/openrc
RUN touch /run/openrc/softlevel
#RUN rc-service mariadb setup
COPY wordpress.sql /wordpress.sql
VOLUME [ "/sys/fs/cgroup" ]
COPY my.cnf /etc/my.cnf
COPY wp-init.sh /wp-init.sh
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
#ENTRYPOINT ./entrypoint.sh

