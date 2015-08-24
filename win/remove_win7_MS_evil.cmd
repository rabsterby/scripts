@echo off
rem Script created by Samoylov Nikolay <github.com/tarampampam> # 2014
rem Version 0.0.2

echo.

call:log "Remove evil M$ updates + block some M$ domains script"
goto:checkPermissions
:begin

echo.

call:log "Uninstall evil MS updates.."
call:log "---------------------------"
call:uninstall_update "3080149"
call:uninstall_update "3075249"
call:uninstall_update "2952664"
call:uninstall_update "3035583"
call:uninstall_update "3050265"
call:uninstall_update "3068708"
call:uninstall_update "3022345"
call:uninstall_update "3021917"
call:uninstall_update "2876229"
call:uninstall_update "2976978"

echo.

call:log "Find and add evil MS servers to HOSTS file.."
call:log "--------------------------------------------"
call:add_to_hosts "vortex-win.data.microsoft.com"
call:add_to_hosts "vortex.data.microsoft.com"
call:add_to_hosts "settings-win.data.microsoft.com"
call:add_to_hosts "settings.data.microsoft.com"

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

:uninstall_update
  call:log "Removing update kb%~1.."
  start /wait wusa /uninstall /norestart /quiet /kb:%~1
  rem echo %errorlevel%
  if %errorlevel%==2359303 call:log "Update kb%~1 not installed"
  if %errorlevel%==1223 call:log "Uninstall cancelled"
  if %errorlevel%==3010 call:log "Update kb%~1 uninstalled successfully"
  exit /b
  
:add_to_hosts
  set HOSTS=%SystemRoot%\system32\drivers\etc\hosts
  set REDIRECT=127.0.0.1
  FIND /C /I "%~1" %HOSTS%>nul
  if %ERRORLEVEL% NEQ 0 (
    echo %REDIRECT% %~1>>%HOSTS%
    call:log "Domain %~1 added to HOSTS file (blocked)"
  ) else (
    call:log "Domain %~1 already blocked"
  )
  exit /b

:end
  echo. && echo Exit after 5 seconds && timeout /t 5 > nul
  echo on
  @exit
