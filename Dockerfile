FROM amazonlinux:2023

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install required app
RUN dnf install -y zip unzip
RUN dnf install -y httpd
RUN dnf install -y php

# Apache configuration
RUN mkdir /run/php-fpm
COPY ./.docker/httpd/laravel.conf /etc/httpd/conf.d/laravel.conf

# Supervisor
RUN dnf install -y python pip
RUN pip install supervisor
RUN mkdir /run/supervisor
RUN mkdir /var/log/supervisor
RUN mkdir /etc/supervisord.d
COPY ./.docker/supervisor/supervisord.conf /etc/supervisord.conf
COPY ./.docker/supervisor/supervisord.d /etc/supervisord.d

WORKDIR /var/www/html

CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
