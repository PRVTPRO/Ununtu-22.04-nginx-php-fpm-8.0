# Ubuntu 22.04 LTS + Nginx + PHP8.0-FPM
Pre-Image Ununtu 22.04+nginx+php-fpm 8.0
## Ubuntu Dockerfile

This repository contains **Dockerfile** of [Ubuntu](http://www.ubuntu.com/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/dockerfile/ubuntu/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).


### Base Docker Image

* [ubuntu:22.04](https://registry.hub.docker.com/u/library/ubuntu/)

### Dockerfile ENV 

    ENV nginx_vhost /etc/nginx/sites-available/default
    ENV php_conf /etc/php/8.0/fpm/php.ini
    ENV nginx_conf /etc/nginx/nginx.conf
    ENV supervisor_conf /etc/supervisor/supervisord.conf

### Volumes
    VOLUME [
    "/etc/nginx/sites-enabled",
    "/etc/nginx/certs",
    "/etc/nginx/conf.d",
    "/var/log/nginx",
    "/var/www/html"
    ]

### Set up PHP repository
    RUN add-apt-repository ppa:ondrej/php 

### apt-get
                  git \
                  libldap-common \
                  nano \
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
                  nginx \
                  php8.0 \
                  php8.0-fpm \
                  php8.0-imap \
                  php8.0-gd \
                  php8.0-apcu \
                  php8.0-ldap \
                  php8.0-intl \
                  php8.0-cli \
                  php8.0-curl \
                  php8.0-mysql \
                  php8.0-mbstring \
                  php8.0-xml

### Installation

1. Install [Docker](https://www.docker.com/).


   (alternatively, you can build an image from Dockerfile: `docker build -t ubuntu.nginx-php8.0 ." 
   https://hub.docker.com/repository/docker/prvtpro/ubuntu22.04-php8.0-fpm`)
   
### RUN
   
    docker run -d -v /home/web:/var/www/html -p 8080:80 --name NAME ubuntu.nginx-php8.0:latest



### Usage

    docker run -it --rm dockerfile/ubuntu
