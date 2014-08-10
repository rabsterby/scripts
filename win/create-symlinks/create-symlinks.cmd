@echo off
rem Script created by Samoylov Nikolay <samoylovnn@gmail.com> # 2014

rem Prerare destination variables

FOR /F "tokens=2*" %%A IN ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop^|FIND /I "Desktop"') DO SET Desktop=%%B
FOR /F "tokens=2*" %%A IN ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal^|FIND /I "Personal"') DO SET My_Docs=%%B


rem Make calls (syntax: "call:createSymLink %%LINK_NAME%% %%LINK_DESTINATION%%")
rem Example: call:createSymLink "My link name" "C:\Windows\Temp"

call:createSymLink "Desktop" %Desktop%
call:createSymLink "My_Documents" %My_Docs%


echo on
@exit /b

:createSymLink
echo %1 ^<==^> %2
IF EXIST %1 rmdir /q %1
mklink /j %1 "%2" >nul 2>&1
exit /b