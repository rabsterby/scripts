#!/bin/bash

## @author    github.com/tarampampam
## @project   Remove most trash and some OSx .hidden cache files from folders
##              (recrussive)
## @copyright 2014 <github.com/tarampampam>
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.1.2
##
## @depends   bash, find, xargs

declare -a PathesArray=("/shares/Public/" "/shares/Public2/")

for Path in "${PathesArray[@]}"; do
  if [ -d "$Path" ]; then
    find "$Path" \( \
      -name "._*" \
      -o -iname ".Apple*" \
      -o -iname ".Temporary*" \
      -o -iname ".apdisk" \
      -o -iname ".DS_Store" \
      -o -iname ".tickle" \
      -o -iname "thumbs.db" \
      -o -iname "desktop.ini" \
      -o -iname "autorun.inf" \
      -o -iname ".Bridge*" \
    \) -print0 | xargs -0 rm -rf
  fi
done;
