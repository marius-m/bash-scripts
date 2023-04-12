#!/bin/bash
REGEX_URL_VALID='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
LINK=$(pbpaste)
if [[ -z $LINK ]]; then
    echo "No link to play"
    exit 1
fi
if [[ ! $LINK =~ $REGEX_URL_VALID ]]
then
    echo "Not a valid URL ('$URL')"
    exit 1
fi

echo "Playing ${LINK}"
mpv $LINK --no-video
