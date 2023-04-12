#!/bin/bash
FILE=$1
NEW_NAME=$(echo $1 | sed s/.mkv/.mpeg/g | sed s/.m4a/.mpeg/g)
if [[ -f $FILE ]]; then
	echo "Converting..."
else
	echo "File not found!"
fi
echo "Converting: $FILE"
#ffmpeg -i $FILE -c:v copy -c:a copy -y $NEW_NAME
ffmpeg -i $FILE $NEW_NAME
echo "Renaming to: $NEW_NAME"
#mv "${FILE}.mp3" "${NEW_NAME}"
#rename "s/${FILE}/.mp3/g" "${FILE}.mp3"
#rm "${FILE}"
