#!/bin/bash

FILE=$1
if [[ -f $FILE ]]; then
    echo "Converting..."
    ffmpeg -i $FILE -vcodec libx264 -crf 20 output.mp4
else
    echo "File not found!"
fi
