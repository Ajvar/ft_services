FROM alpine

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 22 21
RUN printf '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
RUN apk update
RUN apk add pure-ftpd@testing
RUN mkdir -p /etc/ssl/private
RUN apk add supervisor
RUN mkdir /var/log/supervisord

COPY supervisord.conf /etc/supervisord.conf
COPY pure-ftpd.pem /etc/ssl/private
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh /entrypoint.sh
