#!/bin/bash
set -x
INPUT_PACKAGE_NAME=$1
if [[ $# -eq 0 ]] ; then
    echo "Enter package name"
    exit 1
fi

adb shell am set-inactive $INPUT_PACKAGE_NAME false
adb shell am get-inactive $INPUT_PACKAGE_NAME
