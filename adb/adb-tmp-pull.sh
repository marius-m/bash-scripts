#!/bin/bash
echo "Pulling last tmp files"
DIR_PATH="/sdcard/Download"

## Pulling last files from downloads dir
FILES=$(adb shell ls -R $DIR_PATH | egrep "tmp_[0-9]{8}_[0-9]{9}.(jpg|png)")
for FILE in $FILES
do
    echo "File: $FILE"
    adb pull "$DIR_PATH/$FILE"
    adb shell rm "$DIR_PATH/$FILE"
done
