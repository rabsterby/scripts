#!/bin/bash

## @author    github.com/tarampampam
## @project   Send notification from linux shell (using 'curl' and Gmail account)
## @copyright 2014 <github.com/tarampampam>
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.1.3
##
## @depends   curl (>=7.20.0 + ssl)

# *****************************************************************************
# ***                               Config                                   **
# *****************************************************************************

## Folder must be writable (without '/' at the end)
tempFolder="/tmp";

## Gmail account (ex.: username@gmail.com)
gmailUser="yourmail@gmail.com";
## GMail password (*NOT* account password, get it on this page:
##   https://security.google.com/settings/security/apppasswords)
gmailPassword="xxxx xxxx xxxx xxxx";

## Email address - who receive notification (set '$gmailUser' for sending to
##   yourself)
notificationMailTo='yourmail-for-notifications@mail.ru';

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************

## Switch output language to English (DO NOT CHANGE THIS)
export LC_ALL=C;

## Init global variables
NotificationMessage=''; NotificationSubject='Notification';

cRed='\e[1;31m'; cGreen='\e[0;32m'; cNone='\e[0m'; cYel='\e[1;33m';
cBlue='\e[1;34m'; cGray='\e[1;30m';

## Helpers Functions ##########################################################

logmessage() {
  ## $1 = (not required) '-n' flag for echo output
  ## $2 = message to output

  flag=''; outtext='';
  if [ "$1" == "-n" ]; then flag="-n "; outtext=$2; else outtext=$1; fi

  echo -e $flag[$(date +%H:%M:%S)] "$outtext";
}

## Compare 2 versions (strings). Format A.B.C (more (..D.E.F) ignoring)
##   If version1 > version2 = return false
##   If version1 < version2 = return true
##   If version1 = version2 = return true
compareVersion() {
  ## $1 = minimum version (compare with it)
  ## $2 = checked version (check this WITH minimum version)
  local v11 v12 v13 v21 v22 v23 resFalse='false' resTrue='true';
  v11=$(echo $1 | cut -d'.' -f 1); v12=$(echo $1 | cut -d'.' -f 2); v13=$(echo $1 | cut -d'.' -f 3);
  v21=$(echo $2 | cut -d'.' -f 1); v22=$(echo $2 | cut -d'.' -f 2); v23=$(echo $2 | cut -d'.' -f 3);
  #echo $v11 $v12 $v13;
  #echo $v21 $v22 $v23;
  if [ "$v11" == "" ]; then v11=0; fi; if [ "$v21" == "" ]; then v21=0; fi;
  if [ ! -z "$v11" ] && [ ! -z "$v21" ] && [ "$v11" -gt "$v21" ]; then
    echo $resFalse;
  else
    if [ "$v12" == "" ]; then v12=0; fi; if [ "$v22" == "" ]; then v22=0; fi;
    if [ ! -z "$v12" ] && [ ! -z "$v22" ] && [ "$v12" -gt "$v22" ]; then
      echo $resFalse;
    else
      if [ "$v13" == "" ]; then v13=0; fi; if [ "$v23" == "" ]; then v23=0; fi;
      if [ ! -z "$v13" ] && [ ! -z "$v23" ] && [ "$v13" -gt "$v23" ]; then
        echo $resFalse;
      else
        echo $resTrue;
      fi;
    fi;
  fi;
}

## Run script with params #####################################################

## --flush
## Remove all files (temp and base) (except .hidden)
if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "-H" ]; then
  me=$(basename $0);
  echo -e "This script send email notification using your Gmail account. For authorization";
  echo -e "you must edit values in 'settings' section, and also set this:\n";
  echo -e "  ${cYel}tempFolder${cNone}          Must be writable and exists in file system";
  echo -e "  ${cYel}gmailUser${cNone}           Gmail mailbox (ex.: username@gmail.com)";
  echo -e "  ${cYel}gmailPassword${cNone}       Gmail application (${cRed}NOT${cNone} account) password";
  echo -e "  ${cYel}notificationMailTo${cNone}  Address for getting email notification";
  echo -e "\n";
  echo -e "Passing arguments to script:";
  echo -e "  $me ${cYel}$1${cNone}";
  echo -e "    Show this help\n";
  echo -e "  $me ${cYel}\"Notification text\"${cNone}";
  echo -e "    Send email notification with text \"Notification text\"\n";
  echo -e "  $me ${cYel}\"Notification text\"${cNone} ${cBlue}\"Subject text\"${cNone}";
  echo -e "    Send email notification with text \"Notification text\" and subject \"Subject text\"\n";
  exit 0;
fi
## If setted Message
if [ ! "$1" == "" ]; then NotificationMessage=$1; fi
## If setted Subject
if [ ! "$2" == "" ]; then NotificationSubject=$2; fi

## Prepare / Check ############################################################

## Check curl - exists in system or not
curl -V >/dev/null 2>&1 || {
  logmessage "${cRed}curl${cNone} must be installed. Stop script";
  exit 1;
}

## Minimal curl version is '7.20.0' (http://curl.haxx.se/docs/manpage.html#--ssl-reqd)
curlMinimalVersion='7.20.0';
curlActualVersion=$(curl -V | cut -d' ' -f 2 | head -n 1);
if [ ! "$(compareVersion $curlMinimalVersion $curlActualVersion)" == "true" ]; then
  logmessage "curl ${cRed}version${cNone} not valid (installed: $curlActualVersion, needed: $curlMinimalVersion)
For Debian users - run '${cYel}sudo apt-get install curl${cNone}'";
  exit 1;
fi

## Check user values - must be setted
if [[ -z "$gmailUser" ]] || [[ -z "$gmailPassword" ]]; then
  logmessage "${cRed}Empty${cNone} '${cYel}gmailUser${cNone}' or|and '${cYel}gmailPassword${cNone}', check script config";
  exit 1;
fi

## Check temp folder (must exists and be writable)
if [ ! -w $tempFolder ] || [ ! -d $tempFolder ]; then
  logmessage "Directory '$tempFolder' ${cRed}not writable${cNone}. Stop script";
  exit 1;
fi

## Check 'notificationMailTo' value - must be setted
if [ -z $notificationMailTo ]; then
  logmessage "${cRed}Empty${cNone} '${cYel}notificationMailTo${cNone}', check script config";
  exit 1;
fi

## Check user values - must be setted
if [[ -z "$NotificationMessage" ]]; then
  logmessage "${cRed}Empty${cNone} notification message, check syntax ('$(basename $0) ${cYel}-h${cNone}')";
  exit 1;
fi

## Begin work #################################################################

createMailBody() {
  setMailTo=$1; setMailFrom=$2; setMailBody=$3;
  fileName=$tempFolder/notification-mail$(((RANDOM%10000)+100000));

  cat > $fileName <<ENDOFMAILBODY
From: $setMailFrom
To: $setMailTo
Subject: $NotificationSubject

$setMailBody
ENDOFMAILBODY
  echo $fileName;
}

## Generate mail body and get it filename (with path)
mailFileName=$(createMailBody "$notificationMailTo" "$gmailUser" "$NotificationMessage");

logmessage -n "Sending mail notification to ${cYel}$notificationMailTo${cNone}.. ";
## Call curl for making request, and save output to variable
curlResult=$(curl -A "Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20110529 Firefox/4.0" \
  --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "$gmailUser" \
  --mail-rcpt "$notificationMailTo" --user "$gmailUser:$gmailPassword" \
  --verbose --upload-file $mailFileName 2>&1); rm -f $mailFileName;

#echo "$curlResult";  --insecure

if [[ $curlResult == *Authentication\ failed* ]]; then
  echo -e "${cRed}Error${cNone} (${cRed}Authentication failed${cNone})"; exit 1;
fi

if [[ $curlResult == *Couldn\'t\ resolve* ]]; then
  echo -e "${cRed}Error${cNone} (${cRed}Couldn't resolve host${cNone})"; exit 1;
fi

if [[ $curlResult == *couldn\'t\ connect* ]]; then
  echo -e "${cRed}Error${cNone} (${cRed}Couldn't connect to host${cNone},
make check '${cYel}telnet smtp.gmail.com 465${cNone}')"; exit 1;
fi

if [[ $curlResult == *Network\ is\ unreachable* ]]; then
  echo -e "${cRed}Error${cNone} (${cRed}Network is unreachable${cNone})"; exit 1;
fi

if [[ $curlResult == *Access\ denied* ]]; then
  echo -e "${cRed}Error${cNone} (${cRed}Access denied${cNone},
maybe need update your '${cYel}gmailPassword${cNone}' or recompile curl with updated ssl)"; exit 1;
fi

if [[ $curlResult == *host*left\ intact* ]]; then
  echo -e "${cGreen}Success${cNone}"; exit 0;
fi

## If no one substring founded - show more info about error?
echo -e "${cRed}Error${cNone}\nDebug info: \
  \n\n${cYel}$curlResult${cNone}\n\n";
exit 1;
