#!/bin/bash

## Source: https://stackoverflow.com/questions/14432706/adb-command-to-open-settings-and-change-them
# usage: input [text|keyevent]
# input text <string>
# input keyevent <event_code>
#
#set -x

INPUT_KEY=$1
if [[ -z ${INPUT_KEY} ]] ; then
    echo "./adb-emu-app.sh [settings]"
    echo "Ex: ./adb-emu-app.sh settings"
    exit 1
fi

INPUT_CODE=""
case $INPUT_KEY in
  settings)
    INPUT_APP="android.settings.DISPLAY_SETTINGS"
    ;;
  *)
    INPUT_APP=""
    ;;
esac
if [[ -z ${INPUT_APP} ]] ; then
    echo "Invall app name"
    echo "Ex: ./adb-emu-app.sh settings"
    exit 1
fi
adb shell am start -a $INPUT_APP
