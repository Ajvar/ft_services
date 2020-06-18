FROM alpine

RUN apk update \
    apk add pure-ftpd
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh /entrypoint.sh