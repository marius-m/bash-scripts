#!/bin/bash

#set -x
## Source: https://stackoverflow.com/questions/29072501/how-to-unlock-android-phone-through-adb

SLEEP_DURATION_SECS=1
PASSCODE=1111

echo "adb: Lock button"
adb shell input keyevent 26
sleep ${SLEEP_DURATION_SECS}
echo "adb: Tap anywhere"
adb shell input tap 2 2
#sleep ${SLEEP_DURATION_SECS}

#echo "adb: Some event??"
#adb shell input keyevent 930 880
#sleep ${SLEEP_DURATION_SECS}

echo "adb: Swipe up"
## adb shell input swipe <start_x> <start_y> <end_x> <end_y> duration_ms>
adb shell input touchscreen swipe 930 880 930 380 100
#sleep ${SLEEP_DURATION_SECS}

echo "adb: Enter passcode"
adb shell input text ${PASSCODE}
# adb shell input keyevent 6 # Pressing Enter (unnecessary)
