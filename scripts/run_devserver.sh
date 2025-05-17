#!/bin/bash

BIND_ADDR=$1
BIND_PORT=$2
SITE_PATH=$3

if [ -z "$BIND_ADDR" ]; then
    BIND_ADDR="0.0.0.0"
fi

if [ -z "$BIND_PORT" ]; then
    BIND_PORT=1313
fi

if [ -z "$SITE_PATH" ]; then
    SITE_PATH="site"
fi

FULL_BIND_ADDR="$BIND_ADDR:$BIND_PORT"

echo "Starting Hugo dev server on $FULL_BIND_ADDR"
hugo server \
    --source="$SITE_PATH" \
    --bind="$BIND_ADDR" \
    --port="$BIND_PORT"

exit 0
