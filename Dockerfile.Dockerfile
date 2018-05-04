FROM php:7.1-apache
RUN apt-get update
RUN bash -c 'debconf-set-selections <<< "mariadb-server mysql-server/root_password password rootpass" ' \
	&& bash -c 'debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password rootpass" '
RUN apt-get install -y mariadb-server mariadb-client zip libxml2-dev libpng-dev
RUN docker-php-ext-install mysqli simplexml mbstring gd
RUN service mysql start; mysql --password=rootpass -e 'create database smf;'
ADD http://download.simplemachines.org/index.php/smf_2-0-15_install.tar.gz /var/www/
RUN mkdir /var/www/smf; cd /var/www/smf; tar xfz ../smf_2-0-15_install.tar.gz
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD smf.conf /etc/apache2/sites-enabled/
WORKDIR /var/www/smf
RUN chmod 777 attachments avatars cache Packages Packages/installed.list Smileys Themes agreement.txt Settings.php Settings_bak.php
RUN chown -R www-data:www-data .
EXPOSE 80
CMD service mysql start; apache2-foreground
