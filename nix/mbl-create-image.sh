#!/bin/bash

## @author    Samoylov Nikolay
## @project   Make Wd My Book Live Disk Image Copy
## @copyright 2014 <github.com/tarampampam>
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.1.4
##
## @depends   dd, tar, ls, cut, find

# *****************************************************************************
# ***                               Config                                   **
# *****************************************************************************

## Path - where we store images (without '/' at the end)
Path="/DataVolume/shares/Kot/Backup/image";

## Date+Time stamp format (used in file/dir name)
DateTimeStamp=$(date +%Y-%m-%d_%H-%M);

## How long store backups
SaveImagesDaysCount=128;

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************

## Switch output language to English (DO NOT CHANGE THIS)
export LC_ALL=C;

cRed='\e[1;31m'; cGreen='\e[0;32m'; cNone='\e[0m'; cYel='\e[1;33m';
rOk="${cGreen}Ok${cNone}"; rErr="${cRed}Error${cNone}";

logmessage() {
  ## $1 = (not required) '-n' flag for echo output
  ## $2 = message to output

  local flag=''; outtext='';
  if [ "$1" == "-n" ]; then flag="-n "; outtext=$2; else outtext=$1; fi
  echo -e $flag[$(date +%H:%M:%S)] "$outtext";
}

getFileSizeInMiB() {
  ## $1 = (required) File path + name
  if [ -f $1 ]; then
    echo $(($(ls -l "$1" | cut -f 5 -d " ")/1024/1024)); else echo 0;
  fi
}

checkResultFile() {
  if [ ! -z $1 ] && [ -f $1 ]; then
    echo -e "${rOk} ($(getFileSizeInMiB $1) MiB)";
  else
    echo -e "${rErr}";
  fi
}

## Begin work #################################################################

ImagePath=$Path/image-$DateTimeStamp.tmp;

if [ ! -d $ImagePath ]; then
  ## Show some info
  logmessage "${cYel}Note${cNone}: We need about 4.6GiB free space for a \
work. Result archive size ~540MiB, temp files will be deleted";
  echo;
  
  ## Prepare path
  logmessage -n "Create $ImagePath.. "; mkdir -p $ImagePath; echo -e "${rOk}";

  ## Begin create images files
  logmessage -n "Copy MBR and Free space.. "; OF=$ImagePath/sda_mbr_freespace;
  dd if=/dev/sda of=$OF bs=15728640 count=1 > /dev/null 2>&1;
  checkResultFile $OF;

  logmessage -n "Copy /dev/sda1.. "; OF=$ImagePath/sda1_image;
  dd if=/dev/sda1 of=$OF > /dev/null 2>&1;
  checkResultFile $OF;

  logmessage -n "Copy /dev/sda2.. "; OF=$ImagePath/sda2_image;
  dd if=/dev/sda2 of=$OF > /dev/null 2>&1;
  checkResultFile $OF;

  ## Add some info
  echo "Restore and backup info: http://goo.gl/xCWUhJ" > $ImagePath/readme.nfo;

  ## Pack directory with images files to single archive + make clear
  logmessage -n "Move to archive.. "; OF=$Path/image-$DateTimeStamp.tar.bz2;
  tar -cpPjf $OF -C $ImagePath .; rm -Rf $ImagePath; checkResultFile $OF;

  ## Delete old backups (older then $SaveImagesDaysCount)
  logmessage "Search for old images in '$Path' (older then $SaveImagesDaysCount day(s))";
  find $Path -type f -mtime +$SaveImagesDaysCount -exec rm '{}' \;
  for FILE in $(find $Path -mtime +$SaveImagesDaysCount -type f); do
    logmessage "Delete '$FILE' as ${cYel}old${cNone}";
    rm -f $FILE > /dev/null 2>&1;
  done

  logmessage "Work complete";
else
  logmessage "Something is wrong - path already exists. Exit";
  exit 1;
fi
