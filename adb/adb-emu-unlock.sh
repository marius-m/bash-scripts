#!/bin/bash

## Source: https://stackoverflow.com/questions/29072501/how-to-unlock-android-phone-through-adb

adb shell input keyevent 26 # Pressing the lock button
adb shell input touchscreen swipe 930 880 930 380 #Swipe UP
# adb shell input text XXXX # Entering your passcode
adb shell input keyevent 66 # Pressing Enter
