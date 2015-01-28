#!/bin/bash

## @author    Samoylov Nikolay
## @project   Backup system config files
## @copyright 2015 <github.com/tarampampam>
## @github
## @version   0.0.1
##
## @depends

## When OS was installed (setup this value manual)
systemInstalledDay="2015-01-18";
## Create this file with timestamp above
timestampFile="/tmp/sysBackupTimestampFile";
## Store here all modificated files
backupFilesList="/tmp/backupFilesList";
## Fill path to backup file
backupFile="/home/configs-backup/backup-$(date +%y-%m-%d--%H-%M)-systemconfig.tar.bz2";
## Set this owner to result backup file
backupOwner="root:root";
## And this file permissions
backupChmod="0644";

## Switch output language to English (DO NOT CHANGE THIS)
export LC_ALL=C;

cRed='\e[1;31m'; cGreen='\e[0;32m'; cNone='\e[0m'; cYel='\e[1;33m';

## Show log message in console
logmessage() {
  ## $1 = (not required) '-n' flag for echo output
  ## $2 = message to output

  flag=''; outtext='';
  if [ "$1" == "-n" ]; then
    flag="-n "; outtext=$2;
  else
    outtext=$1;
  fi

  echo -e $flag[$(date +%H:%M:%S)] [syscfg] "$outtext";
}


## Get local file size in MiB (if file !exists will return 0)
getFileSizeInKiB() {
    ## $1 = (required) File path + name
    if [ -f $1 ]; then echo $(($(ls -l "$1" | cut -f 5 -d " ")/1024)); else echo 0; fi
}

if [ "$(id -u)" != "0" ]; then
   echo -e $cRed"This script must be run as root"$cNone 1>&2;
   exit 1;
fi;

if [ ! -d $(dirname $backupFile) ]; then
  logmessage -n "Create directory for backup.. ";
  mkdir -p $(dirname $backupFile);
  if [ ! -d $(dirname $backupFile) ]; then
    echo -e $cRed''Error''$cNone;
    exit 1;
  else
    echo -e $cGreen''Ok''$cNone;
  fi;
fi;

logmessage "Create timestamp file.. ";
touch --date "$systemInstalledDay" $timestampFile;

if [ ! -d $timestampFile ]; then
  logmessage -n "Create files list.. ";
  find /etc/ -type f -newer $timestampFile > $backupFilesList;
  newFilesCount=$(wc -l < $backupFilesList);
  echo -e $cYel''$newFilesCount''$cNone' files found';

  if [ $newFilesCount -gt 0 ]; then
    logmessage -n "Archiving files.. ";
    tar -cpjf $backupFile -T $backupFilesList > /dev/null 2>&1;

    if [ -f $backupFile ]; then
      echo -e $cGreen''Complete''$cNone;
      logmessage -n "Set file owner as $cYel$backupOwner$cNone and permissions $cYel$backupChmod$cNone.. ";
      chown $backupOwner $backupFile;
      chmod $backupChmod $backupFile;
      echo -e $cGreen''Yep''$cNone;

      logmessage "Backup file: "$cYel''$backupFile''$cNone' ('$(getFileSizeInKiB $backupFile)' KiB)';

      logmessage -n "Remove temp files.. ";
      rm -f $timestampFile;
      rm -f $backupFilesList;
      echo -e $cGreen''Complete''$cNone;
    else echo -e "$cRedArchive not created$cNone"; fi;
  else echo -e "$cRedModificated files not found$cNone"; fi;
else echo -e "$cRedCannot create timestamp file$cNone"; fi;
