#!/bin/bash

# As this script might be used as docker health check it should exit with either 0/1

EXTERNAL_ADDR=${EXTERNAL_ADDR:-localhost:3013}
INTERNAL_ADDR=${INTERNAL_ADDR:-localhost:3113}
WEBSOCKET_ADDR=${WEBSOCKET_ADDR:-localhost:3014}

echo "Testing external API"
curl -sSf -o /dev/null --retry 6 http://${EXTERNAL_ADDR}/v2/status || exit 2

echo "Testing WebSockets API"
WS_STATUS=$(curl -sS -o /dev/null --retry 6 \
                 -w "%{http_code}" \
                 http://${WEBSOCKET_ADDR}/channel)
# The proxy handles connection upgrade, and we send bad request anyway.
# It shouldn't be 404 so we're good.
test $WS_STATUS -ne 404
