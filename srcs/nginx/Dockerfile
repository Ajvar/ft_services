FROM alpine:3.12.0

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 80 443 22
RUN apk update && apk add openssl nginx supervisor vim openrc --no-cache && apk add --update openssh

RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/nginx-key.key -out /etc/ssl/certs/nginx-cert.crt -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"
RUN mkdir -p /var/log/supervisord /var/www/localhost/htdocs/
COPY SSH.sh /SSH.sh
COPY index.html /var/www/localhost/htdocs
COPY ./config.conf /etc/nginx/nginx.conf
COPY ./supervisord.conf /etc/supervisord.conf

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT sh /SSH.sh
#ENTRYPOINT sh

