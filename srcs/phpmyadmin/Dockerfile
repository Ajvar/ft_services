FROM alpine

LABEL maintainer="jcueille@student.42.fr"

EXPOSE 5000
RUN apk update
RUN apk add nginx
RUN apk add openssl
RUN apk add openrc --no-cache
RUN apk add supervisor
RUN apk add php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype
RUN openrc; touch /run/openrc/softlevel;
RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/nginx-key.key -out /etc/ssl/certs/nginx-cert.crt -subj "/C=FR/ST=PARIS/L=PARIS/O=42/OU=STUDENT/CN=jcueille"
RUN mkdir -p /var/log/supervisord /var/www/localhost/htdocs/ /run/nginx

RUN mkdir -p /usr/share/webapps/
RUN cd /usr/share/webapps && \
    wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz && \
    tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz && \
    rm phpMyAdmin-5.0.2-all-languages.tar.gz && \
    mv phpMyAdmin-5.0.2-all-languages phpmyadmin
#RUN chmod -R 777 /usr/share/webapps/
RUN ln -s /usr/share/webapps/phpmyadmin/ /var/www/localhost/htdocs/phpmyadmin
VOLUME [ "/sys/fs/cgroup" ]
COPY entrypoint.sh /entrypoint.sh
COPY ./config.conf /etc/nginx/nginx.conf
COPY ./supervisord.conf /etc/supervisord.conf
RUN chmod +x ./entrypoint.sh
RUN adduser -D -g 'www' www
ENTRYPOINT ./entrypoint.sh