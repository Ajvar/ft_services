FROM alpine

LABEL maintainer="jcueille@student.42.fr"

ARG WPIP
ARG PHPIP

EXPOSE 80 443 22

RUN echo ${WPIP} >> wpip.txt
RUN echo ${PHPIP} >> phpip.txt

RUN apk update
RUN apk add nginx openssl supervisor
RUN apk add --update openssh-server
RUN apk add openrc --no-cache
RUN openrc; touch /run/openrc/softlevel;
RUN rc-update add sshd
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache

RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/nginx-key.key -out /etc/ssl/certs/nginx-cert.crt -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"
RUN mkdir -p /var/log/supervisord /var/www/localhost/htdocs/ /run/nginx
COPY ./telegraf.conf /etc/telegraf.conf
COPY entrypoint.sh /entrypoint.sh
COPY sshd_config /etc/ssh
COPY index.html /var/www/localhost/htdocs
COPY ./config.conf /etc/nginx/nginx.conf
COPY ./supervisord.conf /etc/supervisord.conf

VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ./entrypoint.sh

