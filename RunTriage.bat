@echo off

echo.
echo Running TriageScript by Ankura (www.ankura.com) ...
echo Please close all running applications.
echo Follow the instructions ...
echo IREC will run first, click START after it starts
echo When IREC finishes processing, close the window (x)
echo Press any key to continue ...
echo.
pause

cd %~dp0
cd "IREC"
start /wait /b IREC-1.6.2.exe
rem echo ""
rem pause
cd ".."
cd "CyLR_win-x64"
start /wait /b CyLR.exe & echo . & echo All Done !
rem pause
rem exit

rem get all AppData folders
cd ".."
cd "Users"
IF EXIST "C:\Documents and Settings\" PUSHD "C:\Documents and Settings\"
FOR /F "tokens=*" %%G in ('dir /a:d-s-h /b') do (
	IF EXIST "%%G\Local Settings\Application Data\" PUSHD "%%G\Local Settings\Application Data\"
	IF NOT %%G == "" md "%~dp0\Users\%%G"
	start /wait /b %~dp0\7z a -t7z -bb0 "AppData.7z" "AppData" && move /y "%%G\Local Settings\Application Data\" "%~dp0\Users\%%G\")
IF EXIST "C:\Users\" PUSHD "C:\Users\"
FOR /F "tokens=*" %%G in ('dir /a:d-s-h /b') do (	
	IF EXIST "C:\Users\%%G" PUSHD "C:\Users\%%G"	
	IF NOT %%G == "" md "%~dp0\Users\%%G"
	IF EXIST "AppData" start /wait /b %~dp0\7z a -t7z -bb0 "AppData.7z" "AppData" && move /y "AppData.7z" "%~dp0\Users\%%G\")
POPD
rem pause
rem exit

setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
set alfanum=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789

set pwd=
FOR /L %%b IN (0, 1, 16) DO (
SET /A rnd_num=!RANDOM! * 62 / 32768 + 1
for /F %%c in ('echo %%alfanum:~!rnd_num!^,1%%') do set pwd=!pwd!%%c
)

rem 7zip Cases folder and CyLR_win-x64\{computer name}.zip
cd %~dp0
start /wait /b 7z a -t7z %ComputerName%.7z -m0=lzma2 -mx=9 -aoa -p%pwd% @listfile.txt
echo.
echo Save the password below (c/p to a text editor just in case) !!!! It will be used to encrypt the 7zip archive.
echo.
echo *************************************
echo     Password = %pwd%
echo *************************************
echo.
pause
echo Success. Press any key to exit ...
rem exit
