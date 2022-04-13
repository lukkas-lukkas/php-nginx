FROM php:8.0.0-fpm-alpine3.12

RUN apk add --no-cache nginx \
    supervisor

COPY docker/ /
COPY . /app

WORKDIR /app

RUN chown -R www-data:www-data /var/lib/nginx

ENTRYPOINT ["/bin/sh", "/app/docker-entrypoint.sh"]