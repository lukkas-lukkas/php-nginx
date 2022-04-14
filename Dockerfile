FROM php:8.0.0-fpm-alpine3.12

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache nginx \
    supervisor

COPY config/ /
COPY . /app

WORKDIR /app

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/app/docker-entrypoint.sh"]