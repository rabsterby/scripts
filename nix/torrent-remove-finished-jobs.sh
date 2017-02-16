#!/bin/sh

## @author      github.com/tarampampam
## @project     Remove downloaded torrents in Transmission torrent client
## @copyright   2014 <github.com/tarampampam>
## @github      https://github.com/tarampampam/scripts/nix/
## @version     0.1.1
##
## @depends     bash, grep, awk, tr, transmission-remote

# Grep all lines with this substring:
#   15 100% 2.3 GiB Done 0.0 0.0 0.00 Idle File.Name.Of.Movie.avi
#                 ^^^^^^
FINISHED=$(transmission-remote -l | grep "B*Done" | tail -n +2)
#echo "$FINISHED"

#Get IDs list grom grepped list
IDS=$(echo "$FINISHED" | awk '{print $1}' | tr [:space:] ",")0
echo " > Jobs IDs list to remove is: '$IDS'"

if [ ! "$IDS" = ",0" ]; then
  # Say to transmission-remote for remove this torrents
  echo -n " > 'transmission-remote' answer is: "; transmission-remote -t $IDS -r
else
  echo " > Nothing to remove"
fi
