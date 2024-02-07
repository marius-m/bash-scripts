#!/bin/bash

## Source: https://stackoverflow.com/questions/14432706/adb-command-to-open-settings-and-change-them
# usage: input [text|keyevent]
# input text <string>
# input keyevent <event_code>
#
#set -x
#
# Source: https://stackoverflow.com/questions/14432706/adb-command-to-open-settings-and-change-them
# com.android.settings
# com.android.settings.APPLICATION_DEVELOPMENT_SETTINGS
# com.android.settings.DISPLAY_SETTINGS
# com.android.settings.DOCK_SETTINGS
# com.android.settings.QUICK_LAUNCH_SETTINGS
# com.android.settings.SOUND_SETTINGS
# com.android.settings.TTS_SETTINGS
# com.android.settings.VOICE_INPUT_OUTPUT_SETTINGS
# android.settings.ACCESSIBILITY_SETTINGS
# android.settings.ACCOUNT_SYNC_SETTINGS
# android.settings.ACCOUNT_SYNC_SETTINGS_ADD_ACCOUNT
# android.settings.ADD_ACCOUNT_SETTINGS
# android.settings.AIRPLANE_MODE_SETTINGS
# android.settings.APN_SETTINGS
# android.settings.APPLICATION_SETTINGS
# android.settings.BLUETOOTH_SETTINGS
# android.settings.DATA_ROAMING_SETTINGS
# android.settings.DATE_SETTINGS
# android.settings.DEVICE_INFO_SETTINGS
# android.settings.DISPLAY_SETTINGS
# android.settings.INPUT_METHOD_SETTINGS
# android.settings.INTERNAL_STORAGE_SETTINGS
# android.settings.LOCALE_SETTINGS
# android.settings.LOCATION_SOURCE_SETTINGS
# android.settings.MANAGE_ALL_APPLICATIONS_SETTINGS
# android.settings.MANAGE_APPLICATIONS_SETTINGS
# android.settings.MEMORY_CARD_SETTINGS
# android.settings.PRIVACY_SETTINGS
# android.settings.SECURITY_SETTINGS
# android.settings.SETTINGS
# android.settings.SOUND_SETTINGS
# android.settings.SYNC_SETTINGS
# android.settings.SYSTEM_UPDATE_SETTINGS
# android.settings.USER_DICTIONARY_SETTINGS
# android.settings.WIFI_IP_SETTINGS
# android.settings.WIFI_SETTINGS
# android.settings.WIRELESS_SETTINGS
# ACCESSIBILITY_FEEDBACK_SETTINGS
# android.net.vpn.SETTINGS
# android.search.action.SEARCH_SETTINGS
# android.search.action.WEB_SEARCH_SETTINGS

INPUT_KEY=$1
if [[ -z ${INPUT_KEY} ]] ; then
    echo "./adb-emu-app.sh [settings]"
    echo "Ex: ./adb-emu-app.sh settings"
    exit 1
fi

INPUT_CODE=""
case $INPUT_KEY in
  display)
    INPUT_APP="android.settings.DISPLAY_SETTINGS"
    ;;
  wifi)
    INPUT_APP="android.settings.WIFI_SETTINGS"
    ;;
  system)
    INPUT_APP="android.settings.SYSTEM_UPDATE_SETTINGS"
    ;;
  *)
    INPUT_APP=""
    ;;
esac
if [[ -z ${INPUT_APP} ]] ; then
    echo "Invall app name"
    echo "Ex: ./adb-emu-app.sh settings"
    exit 1
fi
adb shell am start -a $INPUT_APP
