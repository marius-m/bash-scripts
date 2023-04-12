#!/bin/bash
URL=$1
if [[ $# -eq 0 ]] ; then
    URL=$(pbpaste)
fi
REGEX_URL_VALID='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
if [[ ! $URL =~ $REGEX_URL_VALID ]]
then 
    echo "Not a valid URL ('$URL')"
    exit 1
fi
echo "Opening '${URL}'..."
open -a "Brave Browser" $URL
