FROM nginx:alpine

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 80 443 22
RUN apk update
RUN apk add --update openssh
RUN apk add openrc --no-cache
RUN apk add openssl
RUN apk add supervisor

RUN openssl req -nodes -newkey rsa:2048 -keyout /etc/ssl/private/nginx-key.key -out /etc/ssl/certs/nginx-cert.crt -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"
RUN mkdir /var/log/supervisord
COPY SSH.sh /SSH.sh
COPY ./config.conf /etc/nginx
COPY ./supervisord.conf /etc/supervisord.conf

#ENTRYPOINT sh /SSH.sh
ENTRYPOINT sh

