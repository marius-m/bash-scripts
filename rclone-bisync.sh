#!/bin/bash

# Prevent overlapping runs if a previous sync is still running
pgrep -x "rclone" >/dev/null && exit 0

/opt/homebrew/bin/rclone bisync \
    gdrive: \
    "$HOME/GoogleDrive" \
    --exclude-from ~/scripts/rclone-exclude.txt \
    --verbose \
    --log-file ~/rclone.log \
    --log-file-max-size 10M \
    --log-file-max-age 168h \
    --log-file-max-backups 3 \
    --log-file-compress \
    "$@"
EXIT_CODE=$?

if [ "$EXIT_CODE" -ne 0 ]; then
    /opt/homebrew/bin/terminal-notifier \
        -title "rclone bisync" \
        -message "Sync failed (exit $EXIT_CODE). Check ~/rclone.log" \
        -sound Glass \
        -group rclone-bisync \
        -sender com.apple.Terminal
else
    /opt/homebrew/bin/terminal-notifier \
        -title "rclone bisync" \
        -message "Sync completed successfully." \
        -group rclone-bisync \
        -sender com.apple.Terminal
fi
