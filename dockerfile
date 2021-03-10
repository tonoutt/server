FROM debian:10 

MAINTAINER antton-t <antton-t@student.42.fr>

USER root

ADD /srcs/* /tmp/

RUN apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install	nginx \
				wget \
				mariadb-server \
				wordpress \
                                unzip
RUN rm /var/www/html/index.html
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& wget https://wordpress.org/latest.zip
RUN apt install -y	php \
			php-mbstring \
			php-zip \
			php-mysql \
			php-cli \
			php-fpm

RUN mkdir -p /var/www/html /var/www/info
ADD /srcs/info.php /var/www/info/info.php
RUN  unzip latest.zip -d  /var/www/ \
	&&  mv /tmp/wp-config.php /var/www/wordpress/wp-config.php \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages /var/www/phpmyadmin \
    && mv /tmp/conf_php_myadmin /var/www/phpmyadmin/config.inc.php \
	&& rm latest.zip phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& chown -R www-data:www-data /var/www/* \
	&& chmod -R 755 /var/www/* 

RUN  yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
	&& mv /tmp/conf_nginx /etc/nginx/sites-available/localhost \
	&& ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost \
	&& rm -rf /etc/nginx/sites-enabled/default 

RUN service mysql start \
        && mysql -u root  --password= -e "CREATE DATABASE wordpress;" \
        && mysql -u root --password= -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';" \
        && mysql -u root --password= -e "GRANT ALL ON wordpress.* TO 'wordpress'@'localhost';" \
        && mysql -u root --password= -e "FLUSH PRIVILEGES" 


EXPOSE 80 443


CMD bash /tmp/start_server.sh
