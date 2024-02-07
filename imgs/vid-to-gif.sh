#!/bin/sh
#set -x
export LANG=en_US.UTF-8
INPUT_FILE=$1
FILENAME=$(basename -- "$INPUT_FILE")
EXT="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"
TARGET_EXT="gif"

NEW_NAME_EXT=$(echo $1 | sed s/.${EXT}/-clip.${TARGET_EXT}/g)
if [[ $INPUT_FILE == ${NEW_NAME_EXT} ]]; then
  echo "Same name used for output (${INPUT_FILE})!"
  exit 1
fi

if [[ -f $INPUT_FILE ]]; then
  echo "Converting ($INPUT_FILE -> $NEW_NAME_EXT)..."
else
  echo "File not found (${INPUT_FILE})!"
  exit 1
fi

ffmpeg -ss 01:08:59 -t 11 -i $INPUT_FILE \
    -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 ${NEW_NAME_EXT}
echo "Complete '${NEW_NAME_EXT}'"
