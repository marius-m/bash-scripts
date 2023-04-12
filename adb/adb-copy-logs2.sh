#!/bin/bash

INPUT_PACKAGE=$1
INPUT_FOLDER=$2
if [[ -z ${INPUT_PACKAGE} && -z ${INPUT_FOLDER} ]] ; then
    echo "./adb-copy-logs.sh [app-package-name] [log-folder]"
    exit 1
fi

DEVICE_PATH="/sdcard/Android/data/${INPUT_PACKAGE}/files/Download"
TARGET_PACKAGE=${INPUT_PACKAGE}
TARGET_FOLDER=${INPUT_FOLDER}

echo "- Pulling files"
adb pull "$DEVICE_PATH/$TARGET_FOLDER"

STATUS=$?
[ $STATUS -eq 0 ] && echo "Success downloading logs!"
