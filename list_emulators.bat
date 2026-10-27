@echo off
cd /d "%~dp0"
call "C:\Users\unehi\Flutter SDK\flutter\bin\flutter.bat" emulators > emulators_log.txt 2>&1
echo LISTDONE >> emulators_log.txt
