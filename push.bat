@echo off
chcp 65001 >nul
rem ==========================================
rem  Vue Binding Demo - Commit & Push
rem  Usage: double click, or: push.bat "your message"
rem ==========================================
cd /d "%~dp0"

git add -A
if errorlevel 1 goto :fail

set "MSG=%~1"
if "%MSG%"=="" set /p MSG=Commit message (Enter = "update"): 
if "%MSG%"=="" set MSG=update

git commit -m "%MSG%"
if errorlevel 1 goto :fail

git push
if errorlevel 1 goto :fail

echo.
echo [OK] Pushed to GitHub.

echo.
pause
exit /b 0

:fail
echo.
echo [ERROR] Something went wrong, see message above.
pause
exit /b 1
