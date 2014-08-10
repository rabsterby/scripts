#!/bin/sh

## @author    Samoylov Nikolay
## @project   Remove downloaded torrents in Transmission torrent client
## @copyright 2014 <samoylovnn@gmail.com>
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.1.0
##
## @depends   bash, grep, awk, tr, transmission-remote

# Grep all lines with this substring:
#   15   100%    2.3 GiB  Done         0.0     0.0   0.00  Idle         File.Name.Of.Movie.avi
#                      ^^^^^^^
FINISHED=`transmission-remote -l | grep "B  Done"`
# echo "$FINISHED"

# Get IDs list grom grepped list
IDS=`echo "$FINISHED" | awk '{print $1}' | tr [:space:] ","`0
# echo $IDS

# Say to transmission-remote for remove this torrents
transmission-remote -t $IDS -r
