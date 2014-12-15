#!/bin/bash
## @author    Samoylov Nikolay
## @project   Nic.ru backup script
## @copyright 2014 < samoylovnn {d0g} gmail {d0t} com >
## @github    https://github.com/tarampampam/nic.ru-bascup-script/
## @version   0.1.3
##
## @depends   mysqldump, tar

# *****************************************************************************
# ***                               Config                                   **
# *****************************************************************************

## nic.ru hosting id, look in 'cd ~ && pwd', ex.:
## [%YourID%@web2006 ~]$ cd ~ && pwd
## /home/%YourID%
HostingID=YourID
## Path to home dir, not need in change
PathToHomeDir=/home/$HostingID
## Path to directory, where backups will stored
PathToBackupsDir=$PathToHomeDir/backups
## Path to directory, where store DataBase dumps (add to backup file, and
##   remove from file system), not need in change
PathToDatabaseDumps=$PathToHomeDir/database-backup
##
## !!! IMPORTANT !!!
## Add your login, password and db_name to 'mysqldump' (line ~84)
## !!! IMPORTANT !!!
##
## Days count for backup files store, not need in change
StoreBackupsDaysCount=20
# Path to link file, set empty value ("") for disable this
linkfile=$PathToHomeDir/yoursite.com/docs/dir-with-password/backup-latest.tar.bz2

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************

## Found here - http://goo.gl/4Oi5ZK
cRed='\e[1;31m'; cGreen='\e[0;32m'; cNone='\e[0m'; cYel='\e[1;33m';
cBlue='\e[1;34m'; cGray='\e[1;30m'; cWhite='\e[1;37m';

## Helpers Functions ##########################################################

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

## Begin work #################################################################

# Create directory for backups (if not exists)
if [ ! -d $PathToBackupsDir ]; then
  logmessage -n "Create $PathToBackupsDir.. ";
  mkdir -p $PathToBackupsDir;
  if [ -d $PathToBackupsDir ]; then
    echo -e "${cGreen}Ok${cNone}";
  else
    echo -e "${cRed}Error${cNone}";
    exit 1;
  fi
fi

# Clean temp dumps $PathToDatabaseDumps + create it (ex: broken last run)
logmessage -n "Clean and prepare $PathToDatabaseDumps.. ";
rm -R -f $PathToDatabaseDumps;
mkdir -p $PathToDatabaseDumps;
if [ -d $PathToBackupsDir ]; then
  echo -e "${cGreen}Ok${cNone}";
else
  echo -e "${cRed}Error${cNone}";
fi

logmessage -n "Backup DataBase(s) to $PathToDatabaseDumps.. "
mysqldump --force --opt --add-locks --user=UserName1 -pPassword1 --databases DatabaseName1 > $PathToDatabaseDumps/DatabaseName1.sql
mysqldump --force --opt --add-locks --user=UserName2 -pPassword2 --databases DatabaseName2 > $PathToDatabaseDumps/DatabaseName2.sql
# Write here all files to check exists
if [ -f $PathToDatabaseDumps/DatabaseName1.sql ] && [ -f $PathToDatabaseDumps/DatabaseName2.sql ]; then
  echo -e "${cGreen}Complete${cNone}";
else
  echo -e "${cRed}Error${cNone}";
fi


cd $PathToBackupsDir
thisBackupFileName=backup-$(date +%y-%m-%d--%H-%M)-$HostingID.tar.bz2

logmessage -n "Pack files to $PathToBackupsDir/${cYel}$thisBackupFileName${cNone}.. "
tar -cpPjf $PathToBackupsDir/$thisBackupFileName \
    --exclude=$PathToBackupsDir* \
    --exclude=$PathToHomeDir/dir1/* \
    --exclude=$PathToHomeDir/dir2/* \
    --exclude=$PathToHomeDir/tmp/* \
    --exclude=*httpd.core \
    --exclude=$linkfile \
    $PathToHomeDir;
echo -e "${cGreen}Complete${cNone}";

# Make some clean
logmessage -n "Make some clean.. ";
rm -R -f $PathToDatabaseDumps;
echo -e "${cGreen}Complete${cNone}";

# Make link to latest PathToBackupsDir file
if [ ! "linkfile" == "" ]; then
  logmessage -n "Make link $PathToBackupsDir/$thisBackupFileName ${cYel}<===>${cNone} $linkfile.. ";
  rm -f $linkfile;
  ln $PathToBackupsDir/$thisBackupFileName $linkfile;
  echo -e "${cGreen}Complete${cNone}";
fi

sleep 2s;

## Finish work ################################################################

logmessage -n "Deleting old backups from $PathToBackupsDir.. "
find $PathToBackupsDir -type f -mtime +$StoreBackupsDaysCount -exec rm '{}' \;
for FILE in $(find $PathToBackupsDir -mtime +$StoreBackupsDaysCount -type f); do
  logmessage "${cRed}Deliting${cNone} $FILE as Old";
  rm -f $FILE;
done
echo -e "${cGreen}Complete${cNone}";
