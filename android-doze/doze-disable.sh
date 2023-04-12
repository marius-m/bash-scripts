#!/bin/bash
adb shell dumpsys deviceidle unforce
adb shell dumpsys battery reset
