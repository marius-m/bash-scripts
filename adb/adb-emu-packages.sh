#!/bin/bash
## List out packages in a device
#set -x

# List all installed packages
adb shell "pm list packages" 2>/dev/null | sed 's/package://g' | sort
