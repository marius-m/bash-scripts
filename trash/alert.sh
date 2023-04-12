#!/bin/bash
INPUT=$1
alerter -timeout 1 -message "Msg: '${INPUT}'"
