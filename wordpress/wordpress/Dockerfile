FROM wordpress:php8.0-fpm

RUN apt-get update &&\
    apt-get upgrade -y

# Install build deps
RUN set -ex; \
    apt-mark showmanual > /manual-pkgs.txt; \
    apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libmagickwand-dev \
    libgmp-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libxslt1-dev \
    libzip-dev

# Install PHP Extensions
RUN docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif gettext gmp mysqli pcntl pdo_mysql shmop sockets sysvmsg sysvsem sysvshm xsl opcache zip

RUN pecl install xmlrpc-1.0.0RC2 &&\
    docker-php-ext-enable xmlrpc

RUN pecl install igbinary &&\
    docker-php-ext-enable igbinary

RUN pecl install mcrypt &&\
    docker-php-ext-enable mcrypt

RUN pecl install memcached &&\
    docker-php-ext-enable memcached

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp &&\
    docker-php-ext-install -j$(nproc) gd

# Remove build dependencies
RUN set -ex; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $(cat /manual-pkgs.txt); \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
    | awk '/=>/ { print $3 }' \
    | sort -u \
    | xargs -r dpkg-query -S \
    | cut -d: -f1 \
    | sort -u \
    | xargs -rt apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /tmp/*

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY overrides-php.ini $PHP_INI_DIR/conf.d/zz-overrides.ini
