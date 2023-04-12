#!/bin/bash
#set -x
INPUT_MESSAGE=$1
if [[ $# -eq 0 ]] ; then
    echo "arg1: message"
    exit 1
fi

REQ_BODY_MESSAGE=$(jq --null-input \
  --arg message "$INPUT_MESSAGE" \
  '{"message": $message}')
echo "Sending: $REQ_BODY_MESSAGE"
curl -H "Content-Type: application/json" \
    -X POST \
    -d "$REQ_BODY_MESSAGE" \
    http://app.marius-m.lt/api/v1/fb/devices/send
