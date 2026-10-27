@echo off
cd /d "%~dp0"
set FLUTTER="C:\Users\unehi\Flutter SDK\flutter\bin\flutter.bat"
set LOG=%~dp0setup_log.txt
echo Starting > %LOG%
copy /y lib\main.dart main_backup.dart >> %LOG% 2>&1
call %FLUTTER% create . --project-name signup_app --platforms android >> %LOG% 2>&1
copy /y main_backup.dart lib\main.dart >> %LOG% 2>&1
del main_backup.dart
call %FLUTTER% pub get >> %LOG% 2>&1
call %FLUTTER% analyze >> %LOG% 2>&1
call %FLUTTER% build apk --release >> %LOG% 2>&1
copy /y build\app\outputs\flutter-apk\app-release.apk Activity10_Nehikhuere_Uyiosa.apk >> %LOG% 2>&1
git init -b main >> %LOG% 2>&1
git add . >> %LOG% 2>&1
git commit -m "ICA 10: Flutter signup form with local preset tip feature" -m "Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_01GKD8AQ2HjvD6UcWz2CyUQc" >> %LOG% 2>&1
echo DONE >> %LOG%
