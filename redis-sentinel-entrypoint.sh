#!/bin/bash

rm -f /etc/sentinel.conf

# Launch sentinel-configurator, to create /etc/sentinel.conf
# Repeat until it succeeds
while [ ! -e /etc/sentinel.conf ]; do
    /sentinel-configurator.sh "$@" > /etc/sentinel.conf || rm -f /etc/sentinel.conf
    sleep 0.5
done

echo ">>>>>>>>>> FILE START: /etc/sentinel.conf"
cat /etc/sentinel.conf
echo "<<<<<<<<<< FILE END:   /etc/sentinel.conf"

# Then launch redis-sentinel
exec docker-entrypoint.sh redis-sentinel /etc/sentinel.conf
