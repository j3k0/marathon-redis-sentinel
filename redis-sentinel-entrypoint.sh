#!/bin/bash

# Launch sentinel-configurator, to create /etc/sentinel.conf
/sentinel-configurator.sh "$@" > /etc/sentinel.conf

echo ">>>>>>>>>> FILE START: /etc/sentinel.conf"
cat /etc/sentinel.conf
echo "<<<<<<<<<< FILE END:   /etc/sentinel.conf"

# Then launch redis-sentinel
exec docker-entrypoint.sh redis-sentinel /etc/sentinel.conf
