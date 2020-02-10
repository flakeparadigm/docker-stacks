FROM wordpress:php7.4-fpm

RUN apt-get update &&\
    apt-get upgrade -y

# Install PHP Extensions
RUN apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmagickwand-dev \
    libgmp-dev \
    libxslt1-dev \
    libzip-dev \
    libmcrypt-dev

RUN docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif gettext gmp mysqli pcntl pdo_mysql shmop sockets sysvmsg sysvsem sysvshm xmlrpc xsl opcache zip

RUN pecl install igbinary &&\
    docker-php-ext-enable igbinary

RUN pecl install mcrypt &&\
    docker-php-ext-enable mcrypt

RUN docker-php-ext-configure gd --with-freetype --with-jpeg &&\
    docker-php-ext-install -j$(nproc) gd

RUN apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /tmp/*

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY overrides-php.ini $PHP_INI_DIR/conf.d/zz-overrides.ini
