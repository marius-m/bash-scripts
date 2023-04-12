#!/bin/bash
#set -x
INPUT_TOKEN=$1
INPUT_MESSAGE=$2
if [[ $# -eq 0 ]] ; then
    echo "arg1: token, arg2: message"
    exit 1
fi

REQ_BODY_MESSAGE=$(jq --null-input \
  --arg token "$INPUT_TOKEN" \
  --arg message "$INPUT_MESSAGE" \
  '{"token": $token, "message": $message}')
echo "Sending: $REQ_BODY_MESSAGE"
curl -H "Content-Type: application/json" \
    -X POST \
    -d "$REQ_BODY_MESSAGE" \
    http://app.marius-m.lt/api/v1/fb/send
