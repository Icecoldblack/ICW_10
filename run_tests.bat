@echo off
cd /d "%~dp0"
call "C:\Users\unehi\Flutter SDK\flutter\bin\flutter.bat" test > test_log.txt 2>&1
echo TESTDONE >> test_log.txt
