#!/bin/sh
#set -x
export LANG=en_US.UTF-8
I_FILE=$1
ARG_OVERWRITE=$2
I_OVERWRITE=0
FILENAME=$(basename -- "$I_FILE")
I_EXT="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"
O_EXT="png"

if [[ ! -f $I_FILE ]]; then
  echo "File not found (${I_FILE})!"
  echo "Usage: ./scale_image.sh input_image.png"
  echo "Usage: ./scale_image.sh input_image.png --overwrite"
  exit 1
fi

O_FILE=$(echo $1 | sed s/.${I_EXT}/-small.${O_EXT}/g)
if [[ $I_FILE == ${O_NAME_EXT} ]]; then
  echo "Same name used for output (${I_FILE})!"
  exit 1
fi

if [ "$ARG_OVERWRITE" == "--overwrite" ]; then
  I_OVERWRITE=1
fi

TARGET_WIDTH="1024"
TARGET_HEIGHT="768"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
  echo "Error: ImageMagick is not installed. Install it and try again."
  exit 1
fi

# Get current dimensions of the image
CURRENT_WIDTH=$(identify -format "%w" "$I_FILE")
CURRENT_HEIGHT=$(identify -format "%h" "$I_FILE")

# Check if scaling is needed
if [ "$CURRENT_WIDTH" -le "$TARGET_WIDTH" ] && [ "$CURRENT_HEIGHT" -le "$TARGET_HEIGHT" ]; then
  echo "The image dimensions are within the target resolution. No scaling needed."
  exit 0
fi

# Scale the image while preserving the aspect ratio
convert "$I_FILE" -resize "${TARGET_WIDTH}x${TARGET_HEIGHT}" "$O_FILE"

if [ "$I_OVERWRITE" == 1 ]; then
  echo "Complete with overwrite ($I_FILE)"
  cp $O_FILE $I_FILE
  rm $O_FILE
else 
  echo "Complete $I_FILE -> $O_FILE (${TARGET_WIDTH}x${TARGET_HEIGHT})."
fi

