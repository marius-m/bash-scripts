#!/bin/sh
#set -x
export LANG=en_US.UTF-8

I_FILE=$1
ARG_OVERWRITE=$2
I_OVERWRITE=0
ORIG_FILE="$I_FILE"
FILENAME=$(basename -- "$I_FILE")
I_EXT="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"
O_EXT="png"
I_EXT_LC=$(echo "$I_EXT" | tr '[:upper:]' '[:lower:]')

SUPPORTED_EXTS="png jpg jpeg gif bmp tiff tif webp"

if [ ! -f "$I_FILE" ]; then
  echo "File not found (${I_FILE})!"
  echo "Usage: ./scale-down.sh input_image.png"
  echo "Usage: ./scale-down.sh input_image.png --overwrite"
  exit 1
fi

# Check for unsupported formats
SUPPORTED=0
for ext in $SUPPORTED_EXTS; do
  if [ "$I_EXT_LC" = "$ext" ]; then
    SUPPORTED=1
    break
  fi
done
if [ "$SUPPORTED" = 0 ]; then
  echo "Error: Unsupported format '.${I_EXT}'. Supported formats: ${SUPPORTED_EXTS}."
  echo "For HEIF/HEIC files, use convert-heif.sh first."
  exit 1
fi

O_FILE=$(echo "$1" | sed "s/\.${I_EXT}$/-small.${O_EXT}/")
if [ "$I_FILE" = "$O_FILE" ]; then
  echo "Same name used for output (${I_FILE})!"
  exit 1
fi

if [ "$ARG_OVERWRITE" = "--overwrite" ]; then
  I_OVERWRITE=1
fi

TARGET_WIDTH="1024"
TARGET_HEIGHT="768"

# Check if ImageMagick is installed
if ! command -v convert > /dev/null 2>&1; then
  echo "Error: ImageMagick is not installed. Install it and try again."
  exit 1
fi

# Get current dimensions of the image
CURRENT_WIDTH=$(identify -format "%w" "$I_FILE" 2>/dev/null)
CURRENT_HEIGHT=$(identify -format "%h" "$I_FILE" 2>/dev/null)

# Validate image dimensions
case "$CURRENT_WIDTH" in
  ''|*[!0-9]*)
    echo "Error: Could not read image dimensions from '${ORIG_FILE}'."
    exit 1 ;;
esac
case "$CURRENT_HEIGHT" in
  ''|*[!0-9]*)
    echo "Error: Could not read image dimensions from '${ORIG_FILE}'."
    exit 1 ;;
esac

# Check if scaling is needed
if [ "$CURRENT_WIDTH" -le "$TARGET_WIDTH" ] && [ "$CURRENT_HEIGHT" -le "$TARGET_HEIGHT" ]; then
  echo "The image dimensions are within the target resolution. No scaling needed."
  exit 0
fi

# Scale the image while preserving the aspect ratio
if ! convert "$I_FILE" -resize "${TARGET_WIDTH}x${TARGET_HEIGHT}" "$O_FILE"; then
  echo "Error: Failed to scale the image."
  exit 1
fi

if [ "$I_OVERWRITE" = 1 ]; then
  echo "Complete with overwrite ($ORIG_FILE)"
  cp "$O_FILE" "$ORIG_FILE"
  rm "$O_FILE"
else
  echo "Complete $ORIG_FILE -> $O_FILE (${TARGET_WIDTH}x${TARGET_HEIGHT})."
fi
