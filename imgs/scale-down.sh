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
HEIC_TMP=""
CONVERT_FILE="$I_FILE"
SCRIPT_DIR=$(dirname -- "$0")
DOCKER_IMG="heif-converter"
cleanup() {
  if [ -n "$HEIC_TMP" ] && [ -f "$HEIC_TMP" ]; then
    rm -f "$HEIC_TMP"
  fi
}
trap cleanup EXIT

if [ ! -f "$I_FILE" ]; then
  echo "File not found (${I_FILE})!"
  echo "Usage: ./scale-down.sh input_image.png"
  echo "Usage: ./scale-down.sh input_image.png --overwrite"
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

# HEIC fallback: if identify fails, try Docker
if [ -z "$CURRENT_WIDTH" ] || [ -z "$CURRENT_HEIGHT" ]; then
  if [ "$I_EXT_LC" = "heic" ] || [ "$I_EXT_LC" = "heif" ]; then
    if command -v docker > /dev/null 2>&1; then
      docker image inspect "$DOCKER_IMG" > /dev/null 2>&1 || \
        docker build -t "$DOCKER_IMG" "$SCRIPT_DIR/heif-docker" > /dev/null 2>&1
      if docker image inspect "$DOCKER_IMG" > /dev/null 2>&1; then
        HEIC_TMP="${FILENAME}_heic_$$.png"
        INPUT_DIR=$(dirname "$ORIG_FILE")
        case "$INPUT_DIR" in
          /*) ;;
          .) INPUT_DIR="$PWD" ;;
          *) INPUT_DIR="$PWD/$INPUT_DIR" ;;
        esac
        docker run --rm \
          -v "$INPUT_DIR:/input:ro" \
          -v "$PWD:/output" \
          "$DOCKER_IMG" \
          "/input/$(basename "$ORIG_FILE")" \
          "/output/$HEIC_TMP" 2>/dev/null
        if [ -f "$HEIC_TMP" ]; then
          CURRENT_WIDTH=$(identify -format "%w" "$HEIC_TMP" 2>/dev/null)
          CURRENT_HEIGHT=$(identify -format "%h" "$HEIC_TMP" 2>/dev/null)
          CONVERT_FILE="$HEIC_TMP"
        else
          echo "Error: Docker HEIC conversion failed."
          exit 1
        fi
      else
        echo "Error: Docker is not accessible."
        echo "  Add your user to the docker group:"
        echo "    sudo usermod -aG docker \$USER"
        echo "  Then log out and back in, or run:"
        echo "    sg docker -c \"$0 $*\""
        exit 1
      fi
    else
      echo "Error: Docker not found. Install Docker to process HEIC files,"
      echo "or convert to PNG first."
      exit 1
    fi
  fi
fi

# Validate image dimensions
case "$CURRENT_WIDTH" in
  ''|*[!0-9]*)
    echo "Error: Could not read image dimensions from '$ORIG_FILE'."
    exit 1 ;;
esac
case "$CURRENT_HEIGHT" in
  ''|*[!0-9]*)
    echo "Error: Could not read image dimensions from '$ORIG_FILE'."
    exit 1 ;;
esac

# Check if scaling is needed
if [ "$CURRENT_WIDTH" -le "$TARGET_WIDTH" ] && [ "$CURRENT_HEIGHT" -le "$TARGET_HEIGHT" ]; then
  echo "The image dimensions are within the target resolution. No scaling needed."
  exit 0
fi

# Scale the image while preserving the aspect ratio
if ! convert "$CONVERT_FILE" -resize "${TARGET_WIDTH}x${TARGET_HEIGHT}" "$O_FILE"; then
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

