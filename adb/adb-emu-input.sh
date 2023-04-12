#!/bin/bash

#set -x
CONTENT=$1
if [[ -z "$CONTENT" ]]; then
    CONTENT="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
fi
CONTENT=$(echo "${CONTENT}" | sed 's/ /%s/g')

echo "Sending input ('${CONTENT}')..."
adb shell input text "${CONTENT}"
