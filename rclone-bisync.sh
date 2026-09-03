#!/bin/bash

# Prevent overlapping runs if a previous sync is still running
pgrep -x "rclone" >/dev/null && exit 0

/opt/homebrew/bin/rclone bisync \
    gdrive: \
    "$HOME/GoogleDrive" \
    --verbose
