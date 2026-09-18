#!/usr/bin/env bash
current=$(brightnessctl g)
max=$(brightnessctl m)

echo "$(($current * 100 / $max))"
