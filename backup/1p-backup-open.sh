#!/usr/bin/env bash
set -euo pipefail
gocryptfs "$HOME/1p-backup/cipher" "$HOME/1p-backup/mount"
echo "Vault mounted at ~/1p-backup/mount."
echo "Now: open 1Password -> Export -> 1PUX -> save into ~/1p-backup/mount"
echo "When done, run: ~/scripts/backup/1p-backup-close.sh"
