#!/usr/bin/env bash

awww-daemon 2> /dev/null &

while true; do 
  sleep 600; 
  waypaper --random; 
done
