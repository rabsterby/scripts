@echo off
rem Script created by <github.com/tarampampam> # 2014
rem Version 0.1.7.3

rem Setting variables (NO '"' and NO '\' at the end!)
rem Path for moving Google Chrome Cache
set MoveToThisPath=D:\temp\ChromeUserData

rem --------- DO NOT EDIT BELOW THIS LINE ---------
rem No '"' and No '\' at the end
set GoogleChromeCachePath=%USERPROFILE%\AppData\Local\Google\Chrome
set UserDataDir=User Data

set FlagFileName=CACHE_MOVED
set UserDataTempName=UserData.tmp
set ChoiceTimer=20

echo       _                                                  _
echo      ^| ^|                                                ^| ^|
echo   ___^| ^|__  _ __ ___  _ __ ___   ___       ___ __ _  ___^| ^|__   ___
echo  / __^| '_ \^| '__/ _ \^| '_ ` _ \ / _ \     / __/ _` ^|/ __^| '_ \ / _ \
echo ^| (__^| ^| ^| ^| ^| ^| (_) ^| ^| ^| ^| ^| ^|  __/    ^| (_^| (_^| ^| (__^| ^| ^| ^|  __/
echo  \___^|_^| ^|_^|_^|  \___/^|_^| ^|_^| ^|_^|\___^|     \___\__,_^|\___^|_^| ^|_^|\___^|
echo                                       _
echo                                      (_)
echo                  _ __ ___   _____   ___ _ __   __ _
echo                 ^| '_ ` _ \ / _ \ \ / / ^| '_ \ / _` ^|
echo                 ^| ^| ^| ^| ^| ^| (_) \ V /^| ^| ^| ^| ^| (_^| ^|
echo                 ^|_^| ^|_^| ^|_^|\___/ \_/ ^|_^|_^| ^|_^|\__, ^|
echo                                                __/ ^|
echo                                               ^|___/
echo.
echo.

rem Check admin right
goto:checkPermissions
:begin

rem File-flag is NOT exists
if exist "%GoogleChromeCachePath%\%FlagFileName%" (
  call:log "Cache already moved (file '%FlagFileName%' found)"
  goto:end
)

if not exist "%MoveToThisPath:~0,3%" echo. && call:getPathFromUser && echo.

echo Move Google Chrome cache
echo   Form: "%GoogleChromeCachePath%\%UserDataDir%"
echo   To:   "%MoveToThisPath%"?
echo.
echo Make select:
echo   [Y] - Yes, continue (move to "%MoveToThisPath%")
echo   [C] - Change path (change "%MoveToThisPath%")
echo.
choice /c YC ^
    /t %ChoiceTimer% ^
    /d Y ^
    /m "You have %ChoiceTimer% second(s), default is 'Y'.. "
echo.

if errorlevel 2 (
  rem Pressed C (Change path):
  echo. && call:getPathFromUser && echo.
)

rem http://stackoverflow.com/questions/13915536/yes-no-batch-file
if errorlevel 1 (
  :pressedYes
  rem Pressed Y (YES):

  rem Check exists drive (det first 3 chars from path, ex.: d:\ from d:\some\path)
  if exist "%MoveToThisPath:~0,3%" (
    rem Check path with cache is exists
    if exist "%GoogleChromeCachePath%\%UserDataDir%" (
      setlocal EnableDelayedExpansion

      echo Script log:

      rem Safe check for important variables
      if "%MoveToThisPath%" == "" call:log "Some wrong ('MoveToThisPath' is empty)" && goto:end
      if "%GoogleChromeCachePath%" == "" call:log "Some wrong ('GoogleChromeCachePath' is empty)" && goto:end
      if "%UserDataDir%" == "" call:log "Some wrong ('UserDataDir' is empty)" && goto:end
      if "%FlagFileName%" == "" call:log "Some wrong ('FlagFileName' is empty)" && goto:end
      if "%UserDataTempName%" == "" call:log "Some wrong ('UserDataTempName' is empty)" && goto:end

      tasklist /fi "imagename eq chrome.exe" |find ":" > nul
      if errorlevel 1 (
        set StartGoogleChrome=yes
        call:log "Killing 'chrome.exe'"
        taskkill /f /im chrome.exe > nul && timeout /t 5 /nobreak > nul
      ) else (
        set StartGoogleChrome=no
      )

      if not exist "%MoveToThisPath%" (
        set CreateSymlinkOnly=no
        call:log "Create '%MoveToThisPath%'"
        mkdir "%MoveToThisPath%"
      ) else (
        set CreateSymlinkOnly=yes
      )

      call:log "Rename cache dir to '%UserDataTempName%'"
      rename "%GoogleChromeCachePath%\%UserDataDir%" "%UserDataTempName%"

      call:log "Create symlink"
      mklink /D "%GoogleChromeCachePath%\%UserDataDir%" "%MoveToThisPath%" > nul

      if "!CreateSymlinkOnly!"=="no" (
        call:log "Moving cache files to '%MoveToThisPath%', please wait"
        xcopy /E /H /Q /Y "%GoogleChromeCachePath%\%UserDataTempName%" "%MoveToThisPath%" 2>&1> NUL || call:log "Moving files complete with some errors"
      )

      call:log "Delete old cache ('%UserDataTempName%')"
      del /f /s /q "%GoogleChromeCachePath%\%UserDataTempName%" 2>&1> NUL
      rmdir /s /q "%GoogleChromeCachePath%\%UserDataTempName%" 2>&1> NUL

      call:log "Create 'Flag' file with timestamp"
      echo Moved timestamp : %date% %time% > "%GoogleChromeCachePath%\%FlagFileName%"

      if "!StartGoogleChrome!"=="yes" (
        call:log "Starting 'Google Chrome'"
        start chrome
      )

      endlocal
    ) else (
      call:log "Dir '%UserDataDir%' in profile directory NOT found"
    )
  ) else (
    call:log "Drive for moving (%MoveToThisPath:~0,3%) NOT exists"
  )
)

goto:end

:log
  echo [%time%] %~1
  exit /b

:checkPermissions
  net session >nul 2>&1
  if %errorLevel%==0 (
      rem call:log "Administrative permissions confirmed"
      goto:begin
  ) else (
      call:log "Failure: Need administrative permissions"
      goto:end
  )
  exit /b

:getPathFromUser
  echo Please type valid path (without '\' at the end) for moving cache
  echo   (ex.: D:\Temp\ChromeCache), or press [Ctrl]+[C]:
  set /p MoveToThisPath=
  if not exist "%MoveToThisPath:~0,3%" goto:getPathFromUser
  goto:pressedYes
  exit /b

:end
  echo. && echo Exit after 15 seconds && timeout /t 15 > nul
  echo on
  @exit
