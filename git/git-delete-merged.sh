#!/bin/bash
git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d
