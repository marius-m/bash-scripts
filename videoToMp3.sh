#!/bin/bash
FILE=$1
NEW_NAME=$(echo $1 | sed s/.wav/.mp3/g |sed s/.mp4/.mp3/g | sed s/.mkv/.mp3/g | sed s/.webm/.mp3/g | sed s/.m4a/.mp3/g | sed s/.wma/.mp3/g)
if [[ -f $FILE ]]; then
	echo "Converting..."
else
	echo "File not found!"
fi
echo "Converting: $FILE"
ffmpeg -i "$1" -vn -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 "${FILE}.mp3" 
echo "Renaming to: $NEW_NAME"
mv "${FILE}.mp3" "${NEW_NAME}"
#rename "s/${FILE}/.mp3/g" "${FILE}.mp3"
rm "${FILE}"
