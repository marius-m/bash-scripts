#!/bin/bash

set -x
DATE=$(date)
echo ""
echo "***************************"
echo "Initialize restoring plugins ($DATE)"
echo "***************************"
echo ""
echo ""

## Restoring plugins
HB_CASKS=/opt/homebrew/Caskroom
HB_DBEAVER=$(brew info dbeaver-community | grep ${HB_CASKS} | head -1 | awk '{print $1}')
BACKUP_PLUGIN="vrapper_0.74.0_20181124"
BACKUP_FULL="${DBEAVER_PLUGINS}/${BACKUP_PLUGIN}"

if [[ -z "$HB_DBEAVER" || -z "$DBEAVER_PLUGINS" ]]; then
    echo "Cannot determine DBEAVER version (version: '${HB_DBEAVER}' / plugins: '${DBEAVER_PLUGINS}')"
    exit 1
fi

rsync -avrh "${BACKUP_FULL}/plugins/" "${HB_DBEAVER}/DBeaver.app/Contents/Eclipse/plugins"
rsync -avrh "${BACKUP_FULL}/features/" "${HB_DBEAVER}/DBeaver.app/Contents/Eclipse/plugins"
