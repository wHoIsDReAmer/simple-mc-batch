@REM Chanwook's dev server
@setlocal enableextensions
@cd /d "%~dp0"

set version=1.0

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

if exist configs (
    echo find config
) else (
    mkdir configs
    echo -Xms512M -Xmx1024M > configs/ram.cfg
    echo 0d > configs/color.cfg
)

if exist bukkits (
    echo find bukkits
) else (
    mkdir bukkits
)

:home
@cls
@echo off
title Developer Bukkit %version% - CW Utility Bukkit

for /f "delims=" %%i in (configs/color.cfg) do set cfg=%%i
color 0f
echo.
call :ColorText %cfg% "                    ["
call :ColorText 0e " %username%"
call :ColorText 07 " Welcome"
call :ColorText %cfg% " ]"
echo.
call :ColorText 08 "           Utility Minecraft bukkit (Build %version%)"
echo.
echo.
echo.
call :ColorText 07 "                     (Select menu)";
echo.
echo.
call :ColorText %cfg% "                  └   ["
call :ColorText 0f " 1"
call :ColorText %cfg% " ]"
call :ColorText 07 " Start Server"
echo.
call :ColorText %cfg% "                  └   ["
call :ColorText 0f " 2"
call :ColorText %cfg% " ]"
call :ColorText 07 " Download Bukkit"
echo.
call :ColorText %cfg% "                  └   ["
call :ColorText 0f " 3"
call :ColorText %cfg% " ]"
call :ColorText 07 " Setting"
echo.
call :ColorText %cfg% "                  └   ["
call :ColorText 0f " 4"
call :ColorText %cfg% " ]"
call :ColorText 07 " About"
echo.
call :ColorText %cfg% "[Option]"


set /p option=""

if "%option%" == "1" goto serverstart
if "%option%" == "2" goto downloadbukkit
if "%option%" == "3" goto option
if "%option%" == "4" goto about

:back
goto home

:serverstart
@cls
title Selecting - CW Utility Bukkit
call :ColorText %cfg% "                    [ Select server.. ]"
echo.
call :ColorText 08 "                  ram config ="
echo.

for /f "delims=" %%i in (configs/ram.cfg) do set cfg2=%%i

call :ColorText 08 "                      %cfg2%"
echo.

set index=1
SETLOCAL ENABLEDELAYEDEXPANSION
for /f %%f in ('dir /b bukkits') do (
	set !index!_bkt=%%f
	call :ColorText %cfg% "                    ["
	call :ColorText 07 " !index!"
	call :ColorText %cfg% " ]"
	call :ColorText 0e " %%f"
	echo.
	set /a "index=!index!+1"
)

set /p server=""

if not defined !%server%_bkt! (
    call :ColorText %cfg% "              [ There are not server ]"
    echo.
    call :ColorText %cfg% "                 Press any key.."
    pause > nul
    goto downloadbukkit
) else (
    cd bukkits/!%server%_bkt!
    title Server started.. - CW Utility Bukkit
    echo.
    call :ColorText %cfg% "[ Server started! ]"
    echo.
    java -jar %cfg2% bukkit.jar
)

cd ..
cd ..
echo.
echo - End the server
echo - Press any key..
pause > nul
goto home


:downloadbukkit
title Downloading Bukkit
cls
echo.
call :ColorText %cfg% "                  [ Download servers ]"
echo.
call :ColorText %cfg% "                  1)"
call :ColorText 07 " Spigot"
echo.
call :ColorText %cfg% "                  2)"
call :ColorText 07 " Paper"
echo.
set /p option2=""

if "%option2%" == "" goto home
if %option2% == 1 goto downloadspigot
if %option2% == 2 goto downloadpaper

goto home

:downloadspigot
echo.
call :ColorText %cfg% "             [ input what you want version ]"
call :ColorText 0e " ex) 1.12.2, 1.17 ..."
echo.
set /p option=""
rd bukkits\\spigot-%option% /s /q
mkdir bukkits\\spigot-%option%
@powershell "(New-Object System.Net.WebClient).DownloadFile('https://download.getbukkit.org/spigot/spigot-%option%.jar','bukkits\\spigot-%option%\\bukkit.jar')"
echo.
call :ColorText %cfg% "             [ Successful.. ]"
goto home

:downloadpaper
echo.
call :ColorText %cfg% "             [ input version ]"
call :ColorText 0e " ex) 1.12.2, 1.17 ..."
echo.
set /p option=""

echo.
call :ColorText %cfg% "             [ input build ]"
call :ColorText 0e " ex) 431, 911 ..."
echo.
set /p build=""

rd bukkits\\paper-%option% /s /q > nul
mkdir bukkits\\paper-%option%
@powershell "(New-Object System.Net.WebClient).DownloadFile('https://api.papermc.io/v2/projects/paper/versions/%option%/builds/%build%/downloads/paper-%option%-%build%.jar','bukkits\\paper-%option%\\bukkit.jar')"
echo.
pauses
call :ColorText %cfg% "             [ Successful.. ]"
goto home


:option
cls
echo.
call :ColorText %cfg% "             [ Setting ]"
echo.
echo.
call :ColorText %cfg% "          ["
call :ColorText 07 " 1"
call :ColorText %cfg% " ]"
call :ColorText 07 " Memory"
echo.
call :ColorText %cfg% "          ["
call :ColorText 07 " 2"
call :ColorText %cfg% " ]"
call :ColorText 07 " Color"
echo.
set /p option=""
if "%option%" == "1" goto memset
if "%option%" == "2" goto colset
goto home

:memset
call :ColorText %cfg% "             ["
call :ColorText 07 " Min heap memory (MB)"
call :ColorText %cfg% " ]"
echo.
set /p xms=""
call :ColorText %cfg% "             ["
call :ColorText 07 " Max heap memory (MB)"
call :ColorText %cfg% " ]"
set /p xmx=""
echo -Xms%xms%M -Xmx%xmx%M > configs/ram.cfg
goto home

:colset
call :ColorText %cfg% "             [ input color code ]"
echo.
call :ColorText 07 "                   ex) 0b 0a .."
echo.
echo.
set /p cc=""
echo %cc% > configs/color.cfg
echo 설정 완료!
goto home

:about
cls
call :ColorText %cfg% "                               [ By whoisdreamer ]"
echo.
echo.
call :ColorText 07 "                                  Version %version%"
echo.
call :ColorText %cfg% "                          press any key then go to github"
pause > nul
start https://github.com/whoisdreamer
goto home

:ColorText
rem echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
GOTO :EOF