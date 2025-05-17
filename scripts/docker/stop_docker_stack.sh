#!/bin/bash

CONTAINERS_DIR="./containers"
STACKS_DIR="$CONTAINERS_DIR/stacks/dev"
STACK=$1

if [ -z "$STACK" ]; then
    STACK="compose.yml"
fi

COMPOSE_FILE="$STACKS_DIR/$STACK"

echo "Stopping docker stack: $COMPOSE_FILE"
docker compose -f "$COMPOSE_FILE" down
