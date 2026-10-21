#!/usr/bin/env bash

awww-daemon & disown

while true; do 
  sleep 600; 
  waypaper --random; 
done
