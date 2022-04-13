FROM php:8.0.0-fpm-alpine3.12

RUN apk add --no-cache nginx \
    supervisor

COPY config/ /
COPY . /app

WORKDIR /app

ENTRYPOINT ["/bin/sh", "/app/docker-entrypoint.sh"]