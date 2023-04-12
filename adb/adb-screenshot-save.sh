#!/bin/bash

TARGET_DIR=$(pwd)
TARGET_FILE="$(uuidgen).png"

# Capture a screenshot and save to /sdcard/screen.png on your Android divice.
adb shell screencap -p /sdcard/screen.png

#Grab the screenshot from /sdcard/screen.png to /tmp/screen.png on your PC.
adb pull /sdcard/screen.png /tmp/${TARGET_FILE}

#Delete /sdcard/screen.png
adb shell rm /sdcard/screen.png

#open the screenshot on your PC. 
cp /tmp/${TARGET_FILE} ${TARGET_DIR}

FILE="${TARGET_DIR}/${TARGET_FILE}"
if [[ -f $FILE ]]; then
    echo "Screenshot saved in '${FILE}'"
else
    echo "Error saving screenshot"
fi
