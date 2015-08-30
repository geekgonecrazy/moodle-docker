FROM ubuntu:14.04
MAINTAINER Aaron Ogle <aaron@geekgonecrazy.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

VOLUME ['/var/moodledata']
EXPOSE 80
COPY moodle-config.php /var/www/html/config.php

ENV DRIVER mysqli
ENV MYSQL_HOST mysql
ENV MYSQL_DB moodle
ENV MYSQL_USER moodle
ENV MYSQL_PASSWORD moodle
ENV SITE_URL localhost

RUN apt-get update && \
	apt-get -y install mysql-client pwgen python-setuptools curl git unzip apache2 php5 \
		php5-gd libapache2-mod-php5 postfix wget supervisor php5-pgsql curl libcurl3 \
		libcurl3-dev php5-curl php5-xmlrpc php5-intl php5-mysql git-core && \
	cd /tmp && \
	git clone git://git.moodle.org/moodle.git && \
	cd moodle && git checkout tags/v2.7.7 && \
	rm -rf .git && mv ./* /var/www/html/ && \
	rm /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html 

CMD chown -R www-data:www-data /var/moodledata && \
	chmod 777 /var/moodledata && \
	source /etc/apache2/envvars && \
	apache2 -D FOREGROUND


