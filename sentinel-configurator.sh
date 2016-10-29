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

function masterDefinition() {
cat << EOF

sentinel monitor $1 $2 $3 $QUORUM
sentinel down-after-milliseconds $1 $DOWN_AFTER_MS
sentinel failover-timeout $1 $FAILOVER_TIMEOUT
sentinel parallel-syncs $1 $PARALLEL_SYNCS
EOF
}

function slaveDefinition() {
    echo "sentinel known-slave $1 $2 $3"
}

function makeConfig() {
  header
  for i in $1; do
    NAME=`echo $i | cut -d: -f1`
    PRT=`echo $i | cut -d: -f2`
    SERVERS=`echo $i | cut -d: -f3- | sed 's/,/ /g'`
    N=0
    for SRV in $SERVERS; do
        if [ $N = 0 ]; then
            masterDefinition $NAME $SRV $PRT
        else
            slaveDefinition $NAME $SRV $PRT
        fi
        N=$((N + 1))
    done
  done
}

CONFIG="$@"
makeConfig "$CONFIG"
