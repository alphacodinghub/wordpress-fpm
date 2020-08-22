FROM alpine:3.11
LABEL Maintainer="George Zhou<alpha-coding@outlook.com >" \
  Description="WordPress Docker image with PHP-FPM based on Alpine Linux." \
  Language="php7" \
  OS="Alpine Linux" \
  Service="PHP-FPM" \
  Content="Wordpress with WP-CLI"

# WordPress info
ARG WORDPRESS_VERSION=5.5
ARG WORDPRESS_SHA1=03fe1a139b3cd987cc588ba95fab2460cba2a89e
#ARG WORDPRESS_VERSION=5.4.2
#ARG WORDPRESS_SHA1=e5631f812232fbd45d3431783d3db2e0d5670d2d
#ARG WORDPRESS_VERSION=5.4.1
#ARG WORDPRESS_SHA1=9800c231828eb5cd76ba0b8aa6c1a74dfca2daff
#ARG WORDPRESS_VERSION=5.4
#ARG WORDPRESS_SHA1=d5f1e6d7cadd72c11d086a2e1ede0a72f23d993e

# ensure www-data user exists
RUN set -eux; \
  addgroup -g 82 -S www-data; \
  adduser -u 82 -D -S -G www-data www-data
# 82 is the standard uid/gid for "www-data" in Alpine

RUN apk update && \
  apk --no-cache add \
  # persistent dependencies
  # BusyBox sed is not sufficient for some of our sed expressions
  sed \
  # Ghostscript is required for rendering PDF previews
  ghostscript \
  # Alpine package for "imagemagick" contains ~120 .so files, see: https://github.com/docker-library/wordpress/pull/497
  imagemagick \
  curl \
  openssl \
  tar \
  xz \
  zlib \
  sqlite-libs \
  libsodium \
  bash \
  php \
  php-fpm \
  # wordpress required php extensions
  # graphic libraries for media
  imagemagick-dev \
  #less \
  php7-fpm \
  php7-mysqli \
  php7-json \
  php7-openssl \
  php7-curl \
  php7-zlib \
  php7-xml \
  php7-phar \
  php7-intl \
  php7-dom \
  php7-xmlreader \
  php7-xmlwriter \
  php7-exif \
  php7-fileinfo \
  php7-sodium \
  php7-gd \
  php7-imagick \
  php7-simplexml \
  php7-ctype \
  php7-mbstring \
  php7-zip \
  php7-pdo_mysql \
  # optional
  spl \
  php7-opcache \
  php7-iconv \
  # for optimization using redis-cache plugin
  php7-pecl-redis \
  && rm -rf /var/cache/apk/*

#ghostscript \
#libsodium \

# Configure PHP-FPM
COPY docker-config/fpm-pool.conf /etc/php7/php-fpm.d/zz_docker.conf
COPY docker-config/php.ini /etc/php7/conf.d/zz_php.ini

# wordpress volume
VOLUME /var/www/html
WORKDIR /var/www/html
RUN chown -R www-data.www-data /var/www

RUN mkdir -p /usr/src

# Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \    
  && chown -R www-data.www-data /usr/src/wordpress

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp

# WP config
COPY docker-config/wp-config.php /usr/src/wordpress
RUN chown www-data.www-data /usr/src/wordpress/wp-config.php && chmod 640 /usr/src/wordpress/wp-config.php

# Append WP secrets
COPY docker-config/wp-secrets.php /usr/src/wordpress
RUN chown www-data.www-data /usr/src/wordpress/wp-secrets.php && chmod 640 /usr/src/wordpress/wp-secrets.php

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 9000

CMD ["php-fpm7"]
