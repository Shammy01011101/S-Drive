
@echo off
setlocal EnableExtensions EnableDelayedExpansion
color 2f
title S-Drive by Shammy

echo Cleanup and update S-Drive
echo _____________________________________
echo.
echo Perform this operation often to keep S-Drive
echo virus free and keep all utilities up to date.
echo .
echo For any modifications or suggestions please contact
echo Shammy so he can approve and apply the changes.
echo www.shamrockcossar.com
echo .
echo .

:: ===========================
:: Admin rights check
:: ===========================

net session >nul 2>&1
if %errorlevel%==0 (
    goto update
) else (
    goto fail
)

:update
echo Please enter the drive letter of S-Drive
set /p drltr=


echo For most cases you do not need to format S-Drive
echo !You will need to copy this batch file in order to do so first!
echo Would you like to format S-Drive (y/n)
set /p fmt=


if %fmt% == y echo Formatting...
title S-Drive by Shammy (%drltr%)
if %fmt% == y format %drltr%: /Q /FS:ntfs /x /v:S-Drive

:: ===========================
:: Prepare temp workspace
:: ===========================
set "workRoot=%TEMP%\S-Drive-Source"
if exist "%workRoot%" rd /s /q "%workRoot%"
mkdir "%workRoot%" >nul 2>&1


:: ===========================
:: Download ZIP with PowerShell
:: ===========================
:fetch_zip
echo Fetching ZIP from GitHub 
set "zipMain=%TEMP%\S-Drive-main.zip"


powershell -NoProfile -Command ^
  "$ErrorActionPreference='Stop';" ^
  "try { Invoke-WebRequest -Uri 'https://github.com/Shammy01011101/S-Drive/archive/refs/heads/main.zip' -OutFile '%zipMain%' }" ^
  "catch { Invoke-WebRequest -Uri 'https://github.com/Shammy01011101/S-Drive/archive/refs/heads/master.zip' -OutFile '%zipMaster%' }"

if exist "%zipMain%" (
    powershell -NoProfile -Command "Expand-Archive -LiteralPath '%zipMain%' -DestinationPath '%workRoot%' -Force"
    for /d %%D in ("%workRoot%\S-Drive-main*") do set "work=%%~fD"
) 

:: ===========================
:: Mirror to the target drive
:: ===========================
:copy
echo Updating S-Drive
robocopy "%workRoot%/S-Drive-main/" "%drltr%:/" /E /PURGE /z /xf *.md
goto finish


:finish
echo Finished :)
echo S-Drive by Shammy is up to date



goto end

:fail
echo Please run this script as Administrator to continue
goto end

:end
if exist "%zipMain%" del /q "%zipMain%"
if exist "%zipMaster%" del /q "%zipMaster%"
if exist "%workRoot%" rd /s /q "%workRoot%"
pause

