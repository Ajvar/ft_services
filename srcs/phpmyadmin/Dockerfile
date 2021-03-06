FROM alpine

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add --no-cache nginx openssl supervisor \
	php7-fpm php7-mcrypt php7-session php7-soap php7-openssl php7-gmp \
	php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli \
	php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
	php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
	php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype \
	php7-opcache php7-zlib php7-common php7-iconv php7-xml php7-imap php7-cgi \
	fcgi php7-posix php7-ldap php7-mbstring
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --allow-untrusted --no-cache
RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/nginx-key.key -out /etc/ssl/certs/nginx-cert.crt -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"

RUN mkdir -p /run/nginx/
#COPY ./telegraf.conf /etc/telegraf.conf
# Install PhpMyAdmin
ARG VERSION="phpMyAdmin-5.0.4-all-languages"
RUN wget http://files.directadmin.com/services/all/phpMyAdmin/${VERSION}.tar.gz && \
	tar -xf ${VERSION}.tar.gz && \
	mv ${VERSION} /var/www/phpmyadmin && \
	rm -rf ${VERSION}

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
#COPY ./pma_config.php /var/www/phpmyadmin/config.inc.php

EXPOSE 5000

# SUPERVISOR
COPY ./supervisord.conf /etc/

COPY ./entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
