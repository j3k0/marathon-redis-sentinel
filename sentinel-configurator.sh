#!/bin/bash

if [ "_$QUORUM" = _ ]; then QUORUM=1; fi
if [ "_$DOWN_AFTER_MS" = _ ]; then DOWN_AFTER_MS=30000; fi
if [ "_$FAILOVER_TIMEOUT" = _ ]; then FAILOVER_TIMEOUT=60000; fi
if [ "_$PARALLEL_SYNCS" = _ ]; then PARALLEL_SYNCS=1; fi

function header() {
    if [ _$PORT0 != _ ]; then
        echo port $PORT0
    fi
}

function serversList() {
    (for URL in $@; do
        curl -s $URL | python "`dirname $0`/app-tasks.py" || (echo " => URL failed loading: $URL" 1>&2)
    done) | sort | uniq
}

function masterDefinition() {
cat << EOF

sentinel monitor $1 $2 $3 $QUORUM
sentinel down-after-milliseconds $1 $DOWN_AFTER_MS
sentinel failover-timeout $1 $FAILOVER_TIMEOUT
sentinel parallel-syncs $1 $PARALLEL_SYNCS
EOF
}

function slavesDefinitions() {
    if [ "_$2" != "_" ]; then
        NAME=$1
        echo "$2" | awk '{ print "sentinel known-slave '$NAME'", $1, $2 }'
    fi
}

function makeConfig() {
  header
  for i in $1; do
    NAME=`echo $i | cut -d: -f1`
    URLS=`echo $i | cut -d: -f2- | sed 's/,/ /g'`
    SERVERS=`serversList "$URLS"`
    NSERVERS=`echo "$SERVERS" | wc -l`
    if [ "_$SERVERS" != "_" ]; then
        masterDefinition $NAME `echo "$SERVERS" | head -1`
    fi
    if [ $NSERVERS -gt 1 ]; then
        slavesDefinitions $NAME "`echo "$SERVERS" | tail +2`"
    fi
  done
}

CONFIG="$@"
makeConfig "$CONFIG"
