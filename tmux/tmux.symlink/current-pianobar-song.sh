#!/bin/bash

if [ -z "$(ps aux | grep 'pianobar$')" ]; then
  echo ''
else
  cat ~/.config/pianobar/current-song
fi
