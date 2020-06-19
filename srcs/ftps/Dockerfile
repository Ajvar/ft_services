FROM alpine

LABEL maintainer="jcueille@student.42.fr"

RUN printf '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
RUN apk update
RUN apk add pure-ftpd@testing
RUN mkdir -p /etc/ssl/private

COPY pure-ftpd.pem /etc/ssl/private
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh /entrypoint.sh
