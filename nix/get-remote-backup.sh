#!/bin/bash

## @author    github.com/tarampampam
## @project   Get backup file via HTTP with auth
## @copyright 2014 <github.com/tarampampam>
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.1.4
##
## @depends   curl, wget, sed, awk, cut, find, chmod, chown, rm, mv, grep

# *****************************************************************************
# ***                               Config                                   **
# *****************************************************************************

## Path to dir for storage backups
backupsDir="/home/backups_store";
## Store backups N days
backupsLifeDays=93;
## Hosting ID (for backup file name)
sourceHostingID="MyProjects";
## Set this chmod for backup file (set "" for disable)
chmodTo="0755";
## And owner name (set "" for disable)
chownToUser="Root";

## URL to file for download
backupFileUrl="http://projects.mydomain.ltd/www-folder-with-access-password/backup-latest.tar.bz2";
## login and..
authLogin="MyBasicAuthLogin";
## ..Password for access to file (basic http auth)
authPass="MyPaSSw0rD";

## Temp file name and extension (while downloading) (must be unique)
dlTempName="dl-started-$(date +%y-%m-%d--%H-%M).tar.bz2"; dlTempExt=".part";
## Minimal backup file size in MiB (else show error message and make next
##   download attempt; if attempts limit out - stop the script)
backupMinimalFileSize=1;
## Count of attempts for download file (if file size check failed)
MaxAttemptsCount=10;

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************

## Switch output language to English (DO NOT CHANGE THIS)
export LC_ALL=C;

cRed='\e[1;31m'; cGreen='\e[0;32m'; cNone='\e[0m'; cYel='\e[1;33m';
cBlue='\e[1;34m'; cGray='\e[1;30m';

## Helpers Functions ##########################################################

## Show message with timestamp
logmessage() {
  ## $1 = (not required) '-n' flag for echo output
  ## $2 = message to output

  flag=''; outtext='';
  flag=''; outtext='';
  if [ "$1" == "-n" ]; then
    flag="-n "; outtext=$2;
  else
    outtext=$1;
  fi

  echo -e $flag${cNone}[$(date +%H:%M:%S)] "$outtext"${cRed};
}

## Make download file with custom output
download() {
    ## $1 = (required) URL for download
    local url=$1
    echo -n -e ${cYel}
    echo -n "    "
    wget --http-user="$authLogin" \
        --http-password="$authPass" \
        -O $backupsDir/$dlTempName''$dlTempExt \
        $speedLimit \
        $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo -e " ${cGreen}DONE${cNone}"
}

## Get local file size in MiB (if file !exists will return 0)
getFileSizeInMiB() {
    ## $1 = (required) File path + name
    if [ -f $1 ]; then echo $(($(ls -l "$1" | cut -f 5 -d " ")/1024/1024)); else echo 0; fi
}

## Run script with params #####################################################

if [ "$1" == '-nolimit' ]; then
  speedLimit=""
else
  speedLimit=" --limit-rate=256k "
  logmessage "${cYel}Tip${cNone}: You can run script with flag '${cYel}-nolimit${cNone}' for disable download speed limit"
fi

## Prepare ####################################################################

logmessage "Check access to $backupFileUrl for user '$authLogin'"
checkAvaliableResultCode=$(curl -Is $backupFileUrl --user $authLogin:$authPass | head -n 1 | cut -d' ' -f 2)
if [ "$checkAvaliableResultCode" == '200' ]; then
  logmessage "Access ${cGreen}allowed${cNone} ($checkAvaliableResultCode)";
else
  logmessage "Access ${cRed}error${cNone} \
(HTTP Code: ${cRed}$checkAvaliableResultCode${cNone}). Stop backup";
  echo -ne ${cNone}; exit $checkAvaliableResultCode;
fi

## Begin work #################################################################

# Make some prepare + remove not completed downloads
mkdir -p $backupsDir; cd $backupsDir; rm -f $backupsDir/*$dlTempExt;

attemptCounter=0;
## Begin download attempts loop
while [ ! "$attemptCounter" -ge "$MaxAttemptsCount" ]; do
    logmessage "Download attempt ${cYel}$((attemptCounter+1))${cNone} of $MaxAttemptsCount"

    ## Make download
    logmessage -n "Downloading backup from $backupFileUrl.."
    download $backupFileUrl

    ## Get file creation date and time
    backupCreationDateTime=$(date -r $backupsDir/$dlTempName''$dlTempExt +%y-%m-%d--%H-%M)
    backupFileName="backup-$backupCreationDateTime-$sourceHostingID.tar.bz2"

    ## Make rename
    logmessage "Rename downloaded file to '$backupFileName'"
    mv -f $backupsDir/$dlTempName''$dlTempExt $backupFileName

    backupFileSize=$(getFileSizeInMiB $backupsDir/$backupFileName);
    ## Check file size
    if [ ! "$backupFileSize" -ge "$backupMinimalFileSize" ]; then
        logmessage "Attempt complete with ${cRed}error${cNone} (file size: $backupFileSize, minimal: $backupMinimalFileSize)";
        rm -f $backupsDir/$backupFileName;
        attemptCounter=$((attemptCounter+1));
    else
        ## Set files rights
        if [ ! "$chownToUser" == "" ]; then
            logmessage "Set '${cYel}$chownToUser${cNone}' as file owner";
            chown $chownToUser $backupsDir/$backupFileName;
        fi
        if [ ! "$chmodTo" == "" ]; then
            logmessage "Set file rights (${cYel}$chmodTo${cNone})";
            chmod $chmodTo $backupsDir/$backupFileName;
        fi
        break;
    fi
done;

if [ ! -f $backupsDir/$backupFileName ]; then
    logmessage "${cRed}Fatal error, backup file not downloaded, exit${cNone}";

    #######################################################
    ### WRITE CODE FOR SEND NOTIFICATION FOR ADMIN HERE ###
    #######################################################

    echo -ne ${cNone}; exit 1;
fi

sleep 2s

## Delete old backups
logmessage "Search for old backups in '$backupsDir' (older then $backupsLifeDays day(s))"
find $backupsDir -type f -mtime +$backupsLifeDays -exec rm '{}' \;
for FILE in $(find $backupsDir -mtime +$backupsLifeDays -type f);
do
  logmessage "Delete '$FILE' as old"
  rm -f $FILE
done

echo -ne ${cNone};
