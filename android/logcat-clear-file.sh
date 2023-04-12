#!/bin/bash
TAG="TEST"
FILE_OUT=$1
if [[ ! -f $FILE_OUT ]]; then
    echo "Input file not found! Creating new one."
    touch ${FILE_OUT}
fi
echo "Piping logcat with tag ('${TAG}') to '${FILE_OUT}'"
echo "" > ${FILE_OUT} && adb logcat -c && adb logcat -s "TEST:*" >> ${FILE_OUT}
