#!/bin/sh

cd /app

exec supervisord -c /etc/supervisord.conf
