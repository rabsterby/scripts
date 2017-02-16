@echo off
rem Script created by <github.com/tarampampam> # 2015
rem Version 0.1.0
set BLOCK_SITE_REDIRECT=127.0.0.1
set HOSTS_FILE="%SystemRoot%\system32\drivers\etc\hosts"

goto:checkPermissions
:begin

echo. >> %HOSTS_FILE%
echo ## Skype-ADBlock installed : %date% at %time%>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% devads.skypeassets.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% devapps.skype.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% qawww.skypeassets.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% qaapi.skype.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% preads.skypeassets.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% preapps.skype.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% static.skypeassets.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% serving.plexop.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% preg.bforex.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% ads1.msads.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% flex.msn.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% apps.skype.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% api.skype.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% rad.msn.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% adriver.ru>> %HOSTS_FILE%
echo. >> %HOSTS_FILE%

echo [Info] Sites blocked, %HOSTS_FILE% edited

goto:end

:log
  echo [%time%] %~1
  exit /b

:checkPermissions
  net session >nul 2>&1
  if %errorLevel%==0 (
      goto:begin
  ) else (
      call:log "[Failure] Need administrative permissions"
      goto:end
  )
  exit /b

:end
  echo. && echo Exit after 5 seconds && timeout /t 5 > nul
  echo on
  @exit
