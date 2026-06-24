#!/bin/sh
#set -x
export LANG=en_US.UTF-8

I_FILE=$1
ORIG_FILE="$I_FILE"
FILENAME=$(basename -- "$I_FILE")
I_EXT="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"
I_EXT_LC=$(echo "$I_EXT" | tr '[:upper:]' '[:lower:]')

SCRIPT_DIR=$(dirname -- "$0")
DOCKER_IMG="heif-converter"

if [ ! -f "$I_FILE" ]; then
  echo "File not found (${I_FILE})!"
  echo "Usage: ./convert-heif.sh input_image.heic"
  exit 1
fi

# Ensure the input is a HEIF/HEIC file
if [ "$I_EXT_LC" != "heic" ] && [ "$I_EXT_LC" != "heif" ]; then
  echo "Error: Unsupported format '.${I_EXT}'. Only HEIC/HEIF files are supported."
  exit 1
fi

O_FILE="${FILENAME}-convert.png"

# Check if Docker is available
if ! command -v docker > /dev/null 2>&1; then
  echo "Error: Docker not found. Install Docker to process HEIC/HEIF files."
  exit 1
fi

# Build the Docker image if not already present
if ! docker image inspect "$DOCKER_IMG" > /dev/null 2>&1; then
  echo "Docker image '${DOCKER_IMG}' not found. Building..."
  if ! docker build -t "$DOCKER_IMG" "$SCRIPT_DIR/heif-docker"; then
    echo "Error: Failed to build Docker image '${DOCKER_IMG}'."
    exit 1
  fi
fi

# Verify the image is now available
if ! docker image inspect "$DOCKER_IMG" > /dev/null 2>&1; then
  echo "Error: Docker image '${DOCKER_IMG}' is not accessible."
  echo "  Add your user to the docker group:"
  echo "    sudo usermod -aG docker \$USER"
  echo "  Then log out and back in, or run:"
  echo "    sg docker -c \"$0 $*\""
  exit 1
fi

# Resolve absolute path for input directory
INPUT_DIR=$(dirname "$ORIG_FILE")
case "$INPUT_DIR" in
  /*) ;;
  .) INPUT_DIR="$PWD" ;;
  *) INPUT_DIR="$PWD/$INPUT_DIR" ;;
esac

# Convert using Docker
docker run --rm \
  -v "$INPUT_DIR:/input:ro" \
  -v "$PWD:/output" \
  "$DOCKER_IMG" \
  "/input/$(basename "$ORIG_FILE")" \
  "/output/$O_FILE"

if [ ! -f "$O_FILE" ]; then
  echo "Error: Conversion failed. Output file not created."
  exit 1
fi

echo "Complete $ORIG_FILE -> $O_FILE"
