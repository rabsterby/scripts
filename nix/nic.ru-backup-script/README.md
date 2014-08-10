nic.ru (hosting) backup script
=========

Small script for backup your data on [nic.ru] hosting. Example config:


```
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
## Add your login, password and db_name to 'mysqldump' (line ~80)
## !!! IMPORTANT !!!
##
## Days count for backup files store, not need in change
StoreBackupsDaysCount=20
# Path to link file, set empty value ("") for disable this
linkfile=$PathToHomeDir/yoursite.com/docs/dir-with-password/backup-latest.tar.bz2

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************
```

Installation
--------------

  1. Change values to yours in 'config' section
  2. Edit 'mysqldump' settings and files names in 'if' section (lines ~84 ~87)
  3. Make 'chmod +x make_backup.sh'
  4. Run, add to crontab


**Make love, not war!**

[nic.ru]:http://www.nic.ru/
