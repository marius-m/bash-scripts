#!/bin/bash

LOG_PREFIX() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

if [ "$#" -ne 2 ]; then
    echo "$(LOG_PREFIX) ERROR: Usage: $0 <source> <destination>"
    exit 1
fi

SOURCE=$1
DESTINATION=$2

echo "$(LOG_PREFIX) INFO: Starting sync"
echo "$(LOG_PREFIX) INFO: Source: $SOURCE"
echo "$(LOG_PREFIX) INFO: Destination: $DESTINATION"

if [ ! -e "$SOURCE" ]; then
    echo "$(LOG_PREFIX) ERROR: Source '$SOURCE' does not exist."
    exit 1
fi

echo "$(LOG_PREFIX) INFO: Source exists, beginning transfer..."

rsync -auvhW --progress "$SOURCE" "$DESTINATION" 2>&1 | while IFS= read -r line; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] RSYNC: $line"
done
RSYNC_EXIT=$?

if [ $RSYNC_EXIT -eq 0 ]; then
    echo "$(LOG_PREFIX) INFO: Sync of '$SOURCE' to '$DESTINATION' completed successfully."
else
    echo "$(LOG_PREFIX) ERROR: Sync failed with exit code $RSYNC_EXIT"
    exit $RSYNC_EXIT
fi
