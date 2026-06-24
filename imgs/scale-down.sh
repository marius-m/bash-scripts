#!/bin/sh
#set -x
export LANG=en_US.UTF-8

I_FILE=$1
I_OVERWRITE=0
ORIG_FILE="$I_FILE"
FILENAME=$(basename -- "$I_FILE")
I_EXT="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"
O_EXT="png"
I_EXT_LC=$(echo "$I_EXT" | tr '[:upper:]' '[:lower:]')

# Supported resolutions (16:9): width -> height
# 640x360, 800x450, 1024x576, 1280x720, 1366x768, 1600x900, 1920x1080, 2560x1440, 3840x2160
VALID_WIDTHS="640 800 1024 1280 1366 1600 1920 2560 3840"

resolution_height() {
  case "$1" in
    640)  echo 360  ;;
    800)  echo 450  ;;
    1024) echo 576  ;;
    1280) echo 720  ;;
    1366) echo 768  ;;
    1600) echo 900  ;;
    1920) echo 1080 ;;
    2560) echo 1440 ;;
    3840) echo 2160 ;;
    *)    echo ""   ;;
  esac
}

TARGET_WIDTH="1024"

# Parse optional flags (--overwrite, --resolution <width>)
shift
while [ $# -gt 0 ]; do
  case "$1" in
    --overwrite)
      I_OVERWRITE=1
      shift ;;
    --res)
      if [ -z "$2" ]; then
        echo "Error: --res requires a width value."
        echo "  Valid widths: ${VALID_WIDTHS}"
        exit 1
      fi
      TARGET_WIDTH="$2"
      shift 2 ;;
    *)
      echo "Error: Unknown argument '$1'."
      echo "Usage: ./scale-down.sh input_image.png [--res <width>] [--overwrite]"
      echo "  Valid widths: ${VALID_WIDTHS}"
      exit 1 ;;
  esac
done

TARGET_HEIGHT=$(resolution_height "$TARGET_WIDTH")
if [ -z "$TARGET_HEIGHT" ]; then
  echo "Error: Unsupported resolution width '${TARGET_WIDTH}'."
  echo "  Valid widths: ${VALID_WIDTHS}"
  exit 1
fi

SUPPORTED_EXTS="png jpg jpeg gif bmp tiff tif webp"

if [ ! -f "$I_FILE" ]; then
  echo "File not found (${I_FILE})!"
  echo "Usage: ./scale-down.sh input_image.png [--res <width>] [--overwrite]"
  echo "  Valid widths: ${VALID_WIDTHS}"
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

O_FILE=$(echo "$ORIG_FILE" | sed "s/\.${I_EXT}$/-small.${O_EXT}/")
if [ "$I_FILE" = "$O_FILE" ]; then
  echo "Same name used for output (${I_FILE})!"
  exit 1
fi

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
