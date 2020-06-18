FROM alpine

LABEL maintainer="jcueille@student.42.fr"

RUN apk update \
    apk add pure-ftpd
COPY entrypoint.sh /entrypoint.sh

#ENTRYPOINT sh /entrypoint.sh