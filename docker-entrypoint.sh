#!/bin/sh
set -e

COMMAND=$@

cd /app

chown -R www-data:www-data storage /var/lib/nginx

if [[ "$APP_STAGE" == 'prod' ]]; then
    cp .env.example .env
    composer install
fi

exec $COMMAND

sleep 60