#!/bin/bash
#set -x
INPUT_TOKEN=$1
INPUT_DEVICE=$2
if [[ $# -eq 0 ]] ; then
    echo "arg1: token, arg2: device name"
    exit 1
fi

REQ_BODY_MESSAGE=$(jq --null-input \
  --arg token "$INPUT_TOKEN" \
  --arg deviceName "$INPUT_DEVICE" \
  '{"token": $token, "deviceName": $deviceName}')
echo "Sending: $REQ_BODY_MESSAGE"
curl -H "Content-Type: application/json" \
    -X POST \
    -d "$REQ_BODY_MESSAGE" \
    http://app.marius-m.lt/api/v1/fb/devices/register
