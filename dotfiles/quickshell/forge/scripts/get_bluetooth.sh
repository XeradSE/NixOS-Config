#!/usr/bin/env bash
current=$(bluetoothctl devices)
echo "${current:25}"
