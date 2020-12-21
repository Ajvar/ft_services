FROM alpine

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 30000 21
RUN apk update
RUN apk add openrc --no-cache
RUN apk add vsftpd openssl supervisor
RUN rc-update add vsftpd default
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache

RUN mkdir /var/log/supervisord

RUN openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd-key.key \
    -out /etc/ssl/certs/vsftpd-cert.crt \
    -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"

RUN mkdir /etc/telegraf
COPY ../telegraf.conf /etc/telegraf
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
ENTRYPOINT sh /entrypoint.sh 
