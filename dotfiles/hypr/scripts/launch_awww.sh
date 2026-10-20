#!/usr/bin/env bash

awww-daemon &

while true; do 
  sleep 600; 
  waypaper --random; 
done
