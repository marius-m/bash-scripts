#!/usr/bin/env bash
set -euo pipefail
MOUNT="$HOME/1p-backup/mount"
CIPHER="$HOME/1p-backup/cipher"

if [ -z "$(ls -A "$MOUNT" 2>/dev/null)" ]; then
  echo "Mount is empty — did you actually export the .1pux file? Aborting." >&2
  fusermount -u "$MOUNT"
  exit 1
fi

fusermount -u "$MOUNT"
echo "Vault unmounted. Ciphertext is ready in: $CIPHER"
echo
echo "Now copy that folder to EACH of your backup destinations, e.g.:"
echo "  cp -r $CIPHER /media/\$USER/<drive-1>/1p-backup-cipher"
echo "  cp -r $CIPHER /media/\$USER/<drive-2>/1p-backup-cipher"
echo "  (repeat for every SD card / external drive / other media you use)"
echo
echo "When ALL copies are done, run: ~/scripts/backup/1p-backup-cleanup.sh"
