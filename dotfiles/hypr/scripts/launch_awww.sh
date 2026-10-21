#!/usr/bin/env bash

awww-daemon &

while ! awww query >/dev/null 2>&1; do
  sleep 0.1
done

while true; do 
  sleep 600; 
  waypaper --random; 
done
