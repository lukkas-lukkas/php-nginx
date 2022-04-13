#!/bin/sh
set -e

COMMAND=$@

chown -R www-data:www-data /var/lib/nginx

cd /app

exec supervisord -c /etc/supervisord.conf
