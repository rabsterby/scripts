#!/bin/bash

## @author    Samoylov Nikolay
## @project   Make WD My Book Live Disk Image Copy
## @copyright 2014 <samoylovnn@gmail.com>
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.0.2
##
## @depends   dd, bzip2, find

# *****************************************************************************
# ***                               Config                                   **
# *****************************************************************************

Path=/DataVolume/shares/Kot/Backup/image;
Date=$(date +%y-%m-%d--%H-%M);
backupsLifeDays=128;

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************

## Switch output language to English (DO NOT CHANGE THIS)
export LC_ALL=C;

mkdir -p $Path;

echo "[i] Start backuping"

dd if=/dev/sda bs=15728640 count=1 | bzip2 > $Path/SDA_MBR_FREESPACE_$Date.bz2
dd if=/dev/sda1 | bzip2 > $Path/SDA1_IMA_$Date.bz2
dd if=/dev/sda2 | bzip2 > $Path/SDA2_IMA_$Date.bz2

echo "[i] Search for old backups in '$Path' (older then $backupsLifeDays day(s))"
find $Path -type f -mtime +$backupsLifeDays -exec rm '{}' \;
for FILE in $(find $Path -mtime +$backupsLifeDays -type f);
do
  logmessage "Delete '$FILE' as old"
  rm -f $FILE
done
