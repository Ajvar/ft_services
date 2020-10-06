FROM alpine

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 30000 21 22
RUN apk update
RUN apk add openrc --no-cache
RUN apk add vsftpd
RUN rc-update add vsftpd default
#RUN rc-service vsftpd restart
RUN apk add openssl
#RUN mkdir -p /etc/ssl/private
RUN apk add supervisor
RUN mkdir /var/log/supervisord

RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd-key.key -out /etc/ssl/certs/vsftpd-cert.crt -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"

COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
ENTRYPOINT sh /entrypoint.sh
