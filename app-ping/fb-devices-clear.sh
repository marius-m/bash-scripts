#!/bin/bash
#set -x

curl -H "Content-Type: application/json" \
    -X POST \
    http://app.marius-m.lt/api/v1/fb/devices/clear
