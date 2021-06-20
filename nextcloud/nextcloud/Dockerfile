FROM nextcloud:fpm

# Prep apt
RUN apt-get update && apt-get install -y --no-install-recommends procps smbclient supervisor

# Media processing dependencies
RUN apt-get install -y --no-install-recommends ffmpeg libmagickcore-6.q16-6-extra libopenblas-base libreoffice ocrmypdf tesseract-ocr-all;

# Temporary build dependencies
RUN set -ex; \
    apt-mark showmanual > /manual-pkgs.txt; \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libbz2-dev \
    libc-client-dev \
    libkrb5-dev \
    libopenblas-dev \
    libsmbclient-dev \
    libx11-dev;

# Build image recognition libs
ARG DLIB_BRANCH=v19.22
RUN set -ex; \
    mkdir /dlib-build; \
    cd /dlib-build; \
    curl -sSL https://github.com/davisking/dlib/archive/$DLIB_BRANCH.tar.gz -o dlib.tar.gz; \
    tar xf dlib.tar.gz; \
    mv dlib-* dlib-src; \
    cd dlib-src/dlib; \
    mkdir build; \
    cd build; \
    cmake -DBUILD_SHARED_LIBS=ON --config Release ..; \
    make -j$(nproc); \
    make install; \
    cd /dlib-build; \
    mkdir -p /usr/src/php/ext; \
    curl  -sSL https://github.com/goodspb/pdlib/archive/master.tar.gz -o pdlib.tar.gz; \
    tar xf pdlib.tar.gz -C /usr/src/php/ext; \
    cd /; \
    rm -r ./dlib-build;

# Build PHP Extensions
RUN set -ex; \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install \
    bz2 \
    imap \
    pdlib-master; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient;

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
    rm -rf /var/lib/apt/lists/*;

# PHP Config tweaks
RUN sed -i 's/pm.max_children = [[:digit:]]\+/pm.max_children = 16/' /usr/local/etc/php-fpm.d/www.conf
ENV PHP_MEMORY_LIMIT=2G
ENV NEXTCLOUD_UPDATE=1

# Cron & Supervisord setups
RUN printf "*/10 * * * * php -f /var/www/html/occ preview:pre-generate\n" >> /var/spool/cron/crontabs/www-data; \
    printf "*/30 * * * * php -f /var/www/html/occ face:background_job -t 900\n" >> /var/spool/cron/crontabs/www-data;
RUN mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord;
COPY supervisord.conf /
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
