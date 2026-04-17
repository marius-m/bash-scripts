#!/bin/bash

F_INPUT=$1

if [[ -z ${F_INPUT} ]] ; then
    echo "File not found!"
    echo "Ex: ./compress.sh input.mp4"
    exit 1
fi


F_NAME=$(basename -- "$F_INPUT")
F_EXT="${F_NAME##*.}"
F_NAME="${F_NAME%.*}"
F_OUT=$(echo $1 | sed s/.$F_EXT/-compressed.$F_EXT/g)
GUID=$(uuidgen)
F_TMP="tmp-${GUID}.mp4"

echo "Converting... (${F_INPUT} -> ${F_OUT})"
#ffmpeg -i "$F_INPUT" -vcodec libx264 -crf 20 "output.mp4"
ffmpeg -i "$F_INPUT" -vf "scale=1280:720" -c:v libx264 -preset slow -crf 23 -c:a aac -b:a 128k "$F_TMP"
mv "$F_TMP" "$F_OUT"
