#!/bin/bash
if ! pgrep -x rofi > /dev/null 2>&1; then
    exec rofi -show window
fi