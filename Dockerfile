FROM php:7.4.9-fpm-alpine3.12

ENV RBKAFKA_VERSION='3.1.1'
ENV XDEBUG_VERSION='2.9.8'
ENV APP_STAGE='prod'

RUN apk --update add --no-cache \
    ${PHPIZE_DEPS} \
    libpng-dev \
    openssl-dev \
    gd \
    "libxml2-dev>=2.9.10-r5" \
    git \
    "freetype>=2.10.4-r0" \
    && rm -rf /var/cache/apk/*

RUN apk update && \
    apk del oniguruma && \
    wget -c https://github.com/kkos/oniguruma/releases/download/v6.9.6_rc4/onig-6.9.6-rc4.tar.gz -O - | tar -xz && \
    (cd onig-6.9.6 && ./configure && make install) && \
    rm -rf ./onig-6.9.6 && \
    rm -rf /var/cache/apk/*

RUN docker-php-ext-install \
        mbstring \
        gd \
        soap \
        xml \
        posix \
        tokenizer \
        ctype \
        pcntl \
        opcache \
        && echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
        && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
        && pecl install -f apcu \
        && echo 'extension=apcu.so' > /usr/local/etc/php/conf.d/30_apcu.ini \
        && chmod -R 755 /usr/local/lib/php/extensions/ \
        && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
        && mkdir -p /app \
        && chown -R www-data:www-data /app

WORKDIR /app

#ENTRYPOINT ["sh", "-c"]

RUN apk add --no-cache nginx \
    supervisor

RUN apk add --no-cache librdkafka-dev \
    && pecl install rdkafka-${RBKAFKA_VERSION} \
    && docker-php-ext-enable rdkafka

RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-enable pdo_mysql

COPY docker/ /

COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

COPY composer.* /app/

WORKDIR /app

RUN if [ "$APP_STAGE" = "prod" ] ; then \
        composer install --no-autoloader --no-interaction; else \
        composer install --no-autoloader --no-interaction --no-dev --no-scripts; \
    fi

COPY . /app

RUN composer dump-autoload --no-scripts --optimize \
    && rm -rf /root/.composer

ENTRYPOINT ["/bin/sh", "/app/docker-entrypoint.sh"]