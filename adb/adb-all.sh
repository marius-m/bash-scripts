#!/bin/bash
## Runs a piped command on all devices
## Source: https://stackoverflow.com/questions/17882474/running-adb-commands-on-all-connected-devices

adb devices | while read -r line
do
if [ ! "$line" = "" ] && [ "$(echo "$line" | awk '{print $2}')" = "device" ]
then
    device=$(echo "$line" | awk '{print $1}')
    echo "$device" "$@" ...
    adb -s "$device" "$@"
fi
done
