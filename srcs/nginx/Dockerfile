FROM nginx:alpine

LABEL maintainer="jcueille@student.42.fr"

RUN apk add --update openssh
COPY SSH.sh /SSH.sh
ENTRYPOINT sh /SSH.sh

EXPOSE 80 443 22