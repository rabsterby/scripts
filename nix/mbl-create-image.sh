#!/bin/bash

## @author    Samoylov Nikolay
## @project   Make Wd My Book Live Disk Image Copy
## @copyright 2014 <samoylovnn@gmail.com>
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.1.2
##
## @depends   dd, sfdisk, tar, ls, cut, find

# *****************************************************************************
# ***                               Config                                   **
# *****************************************************************************

Path="/DataVolume/shares/Kot/Backup/image";
Date=$(date +%y-%m-%d--%H-%M);
ImagePath=$Path/image-$Date;
backupsLifeDays=128;

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************

## Switch output language to English (DO NOT CHANGE THIS)
export LC_ALL=C;

cRed='\e[1;31m'; cGreen='\e[0;32m'; cNone='\e[0m'; cYel='\e[1;33m';

logmessage() {
  ## $1 = (not required) '-n' flag for echo output
  ## $2 = message to output

  flag=''; outtext='';
  if [ "$1" == "-n" ]; then
    flag="-n "; outtext=$2;
  else
    outtext=$1;
  fi

  echo -e $flag[$(date +%H:%M:%S)] "$outtext";
}

getFileSizeInMiB() {
    ## $1 = (required) File path + name
    if [ -f $1 ]; then echo $(($(ls -l "$1" | cut -f 5 -d " ")/1024/1024)); else echo 0; fi
}

## Begin work #################################################################

if [ ! -d $ImagePath ]; then
  logmessage "${cYel}Note${cNone}: We need about ~4.1GiB free space for a work";
  logmessage -n "Create $ImagePath.. ";
  mkdir -p $ImagePath; echo -e "${cGreen}Ok${cNone}";

  logmessage -n "Copy MBR and Free space at beginning on the drive.. ";
  OutFile=$ImagePath/sda_mbr_freespace;
  dd if=/dev/sda of=$OutFile bs=15728640 count=1 > /dev/null 2>&1
  if [ -f $OutFile ]; then
    echo -e "$(getFileSizeInMiB $OutFile)MiB, ${cGreen}Ok${cNone}";
  else
    echo -e "${cRed}Error${cNone}";
  fi

  logmessage -n "Copy /dev/sda1.. ";
  OutFile=$ImagePath/sda1_image;
  dd if=/dev/sda1 of=$ImagePath/sda1_image > /dev/null 2>&1
  if [ -f $OutFile ]; then
    echo -e "$(getFileSizeInMiB $OutFile)MiB, ${cGreen}Ok${cNone}";
  else
    echo -e "${cRed}Error${cNone}";
  fi

  logmessage -n "Copy /dev/sda2.. ";
  OutFile=$ImagePath/sda2_image;
  dd if=/dev/sda2 of=$ImagePath/sda2_image > /dev/null 2>&1
  if [ -f $OutFile ]; then
    echo -e "$(getFileSizeInMiB $OutFile)MiB, ${cGreen}Ok${cNone}";
  else
    echo -e "${cRed}Error${cNone}";
  fi

  logmessage -n "Getting partitions table info for /dev/sda.. ";
  OutFile=$ImagePath/sda_ptable;
  sfdisk -d /dev/sda > $OutFile 2>&1
  if [ -f $OutFile ]; then
    echo -e "${cGreen}Ok${cNone}";
  else
    echo -e "${cRed}Error${cNone}";
  fi

  echo "Backup based on this post: http://mybookworld.wikidot.com/backup-images-of-mybook" > $ImagePath/readme.nfo

  logmessage -n "Move images to archive.. ";
  OutFile=$Path/image-$Date.tar.bz2;
  tar -cpPjf $OutFile -C $ImagePath .; rm -Rf $ImagePath;
  if [ -f $OutFile ]; then
    echo -e "${cGreen}$(getFileSizeInMiB $OutFile)MiB, Ok${cNone}";
  else
    echo -e "${cRed}Error${cNone}";
  fi

  logmessage "Search for old images in '$ImagePath' (older then $backupsLifeDays day(s))"
  find $ImagePath -type f -mtime +$backupsLifeDays -exec rm '{}' \;
  for FILE in $(find $ImagePath -mtime +$backupsLifeDays -type f); do
    logmessage "Delete '$FILE' as old"
    rm -f $FILE
  done

  logmessage "Work complete";
else
  logmessage "Something is wrong - path already exists. Exit";
  exit 1;
fi
