#!/bin/bash
FILE=$1
NEW_NAME=$(echo $1 | sed s/.mkv/.mp4/g | sed s/.m4a/.mp4/g | sed s/.webm/.mp4/g)
if [[ -f $FILE ]]; then
	echo "Converting ${FILE}..."
else
	echo "File not found!"
fi
echo "Converting: $FILE"
RES_W=800
#RES_H=320
## Source: https://stackoverflow.com/questions/34391499/change-video-resolution-ffmpeg
#FFMPEG_VF="[in]scale=iw*min(${RES_W}/iw\,${RES_H}/ih):ih*min(${RES_W}/iw\,${RES_H}/ih)[scaled]; [scaled]pad=${RES_W}:${RES_H}:(${RES_W}-iw*min(${RES_W}/iw\,${RES_H}/ih))/2:(${RES_H}-ih*min(${RES_W}/iw\,${RES_H}/ih))/2[padded]; [padded]setsar=1:1[out]" 
FFMPEG_VF="scale=${RES_W}:-2,setsar=1:1" 

## Source: https://superuser.com/questions/319542/how-to-specify-audio-and-video-bitrate
FFMPEG_BITRATE_V=1500
FFMPEG_BITRATE_A=96000

## Source: https://stackoverflow.com/questions/45462731/using-ffmpeg-to-change-framerate
FFMPEG_FRAMERATE=30
ffmpeg -i "$FILE" -c:a aac -c:v libx264 -vf ${FFMPEG_VF} -r ${FFMPEG_FRAMERATE} -b:v ${FFMPEG_BITRATE_V}k -b:a ${FFMPEG_BITRATE_A}k -y "$NEW_NAME"

echo "Renaming to: $NEW_NAME"
