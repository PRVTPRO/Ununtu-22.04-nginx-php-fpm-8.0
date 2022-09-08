#Download base image ubuntu 22.04
FROM ubuntu:22.04

# Добавим подробную информацию о пользовательском образе, используя инструкцию LABEL.
LABEL maintainer="OSticket last version by perfect people"
LABEL version="0.1"
LABEL description="This is custom Docker Image for \
the PHP-FPM and Nginx Services."

#Определим новую переменную среды, которая может быть передана в пользовательский образ.
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/8.0/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf

# Используя переменную среды ‘DEBIAN_FRONTEND = noninteractive’ мы предотвратим интерактивные запросы при запуске команды apt.
ARG DEBIAN_FRONTEND=noninteractive

### Dependency Installation
RUN set -ex && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
                  git \
                  libldap-common \
                  openssl \
                  php${PHP_BASE}-memcached \
                  tar \
                  wget \
                  zlib1g \
                  curl \
                  software-properties-common \
                  ### Install required dependencies
                  gnupg2 \
                  ca-certificates \
                  lsb-release \
                  apt-transport-https \
                  supervisor 
### Set up PHP repository
RUN add-apt-repository ppa:ondrej/php 
###Install PHP 8 on Ubuntu 22.04
RUN apt-get install -y \
                  nginx \
                  php8.0 \
                  php8.0-fpm \
                  php8.0-cli \
                  php8.0-curl \
                  php8.0-mysql \
                  php8.0-mbstring \
                  php8.0-xml  

# Теперь скопируем конфигурацию Nginx по умолчанию в переменную ‘nginx_vhost’,
# заменим в файле конфигурации php.ini’cgi.fix_pathinfo = 1′ на ‘cgi.fix_pathinfo = 0’
# и добавим опцию ‘daemon off’ в ‘nginx_conf’.
COPY default ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
echo "\ndaemon off;" >> ${nginx_conf}
#Copy supervisor configuration
COPY supervisord.conf ${supervisor_conf}
# Изменим владельца корневого каталога веб-сервера «/var/www/html», создадим новый каталог «/run/php» и назначим права на него пользователю «www-data».
RUN mkdir -p /run/php && \ 
chown -R www-data:www-data /var/www/html && \
chown -R www-data:www-data /run/php
# Определите том для пользовательского образа, чтобы мы могли смонтировать все эти каталоги на хост-машине.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
# Теперь добавим скрипт start.sh и определим команду контейнера по умолчанию, используя инструкцию CMD, как показано ниже.
COPY start.sh /start.sh
CMD ["./start.sh"]
# с помощью команды EXPOSE откроем в контейнере порты HTTP и HTTPS.
EXPOSE 80 443


### CHECK WEB STATUS
### HEALTHCHECK CMD curl -fIsS http://localhost/ || exit 1