#!/bin/bash

# Prevent overlapping runs if a previous sync is still running
pgrep -x "rclone" >/dev/null && exit 0

# Rotate log if >10MB
LOG="$HOME/rclone-bisync.log"
if [ -f "$LOG" ]; then
    LOG_SIZE=$(stat -f%z "$LOG" 2>/dev/null || echo 0)
    if [ "$LOG_SIZE" -gt 10485760 ]; then
        tail -1000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
    fi
fi

/opt/homebrew/bin/rclone bisync \
    gdrive: \
    "$HOME/GoogleDrive" \
    --exclude-from ~/scripts/rclone-exclude.txt \
    --verbose \
    "$@"
EXIT_CODE=$?

if [ "$EXIT_CODE" -ne 0 ]; then
    terminal-notifier \
        -title "rclone bisync" \
        -message "Sync failed (exit $EXIT_CODE). Check ~/rclone-bisync.log" \
        -sound Glass \
        -group rclone-bisync
else
    terminal-notifier \
        -title "rclone bisync" \
        -message "Sync completed successfully." \
        -group rclone-bisync
fi
