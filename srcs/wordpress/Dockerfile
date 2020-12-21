FROM alpine

LABEL maintainer="jcueille@student.42.fr"

WORKDIR /tmp
ARG IP
EXPOSE 5050
RUN apk update
RUN apk add openssl supervisor
RUN apk add openrc --no-cache
RUN apk add nginx php7-fpm php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-cli php7-opcache
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache

RUN adduser -D -g 'www' www
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www
RUN mkdir -p /usr/share/webapps/
RUN wget http://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm latest.tar.gz
RUN chown -R www /usr/share/webapps/
RUN mv wordpress /usr/share/webapps
RUN ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress
RUN openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"
RUN mkdir -p /run/nginx
RUN mkdir /etc/telegraf
COPY ../telegraf.conf /etc/telegraf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /tmp
COPY supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisord
COPY wp-config.php /usr/share/webapps/wordpress
RUN touch IP.txt
RUN echo ${IP} > IP.txt
RUN chmod +x entrypoint.sh
ENTRYPOINT ./entrypoint.sh

