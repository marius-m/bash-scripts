#!/usr/bin/env bash
set -euo pipefail
read -p "Have you finished copying ~/1p-backup/cipher to every backup destination? [y/N] " ok
if [ "$ok" != "y" ] && [ "$ok" != "Y" ]; then
  echo "Not logging completion yet — copy the vault to all destinations first, then re-run this script."
  exit 1
fi
echo "Backup complete: $(date -Iseconds)" >> ~/1p-backup/backup.log
echo "Logged. Safely unmount/eject each backup drive or SD card before disconnecting it."
