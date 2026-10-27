@echo off
REM Pushes this project to https://github.com/Icecoldblack/ICW_10
cd /d "%~dp0"
git remote remove origin 2>nul
git remote add origin https://github.com/Icecoldblack/ICW_10.git
git push -u origin main > "%~dp0push_log.txt" 2>&1
echo exit %errorlevel% >> "%~dp0push_log.txt"
