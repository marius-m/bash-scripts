#!/bin/bash

FILE=$1
if [[ -f $FILE ]]; then
    echo "Converting..."
    #ffmpeg -i $FILE -vcodec libx264 -crf 20 output.mp4
    ffmpeg -i $FILE -vf "fps=10,scale=1024:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output.gif
else
    echo "File not found!"
fi
