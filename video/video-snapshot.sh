#!/bin/bash
TIME="00:00:04"
FILE=$1
OUT_EXT="png"
FILE_NEW=$(echo $1 | sed s/.mkv/.${OUT_EXT}/g | sed s/.m4a/.${OUT_EXT}/g | sed s/.webm/.${OUT_EXT}/g)
if [[ ! -f $FILE ]]; then
	echo "File not found!"
	exit 1
fi
echo "Snapshotting: $FILE -> ${FILE_NEW}"
ffmpeg -ss "${TIME}" -i "${FILE}" -frames:v 1 -q:v 2 "${FILE_NEW}"
echo "Renaming to: $NEW_NAME"
