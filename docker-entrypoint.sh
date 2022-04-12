#!/bin/sh
set -e

COMMAND=$@

cd /app

chown -R www-data:www-data /var/lib/nginx

exec supervisord -c /etc/supervisord.conf

sleep 60