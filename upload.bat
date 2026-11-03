@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo             Git Auto Commit ^& Push
echo ===================================================
echo.

git status
echo.

set "commit_msg=%~1"

if "%commit_msg%"=="" (
    set /p "commit_msg=Enter commit message (press Enter for default): "
)

if "%commit_msg%"=="" (
    set commit_msg=Update scripts and documentation
)

echo.
echo [+] Adding changes to git...
git add .

echo [+] Committing changes: "%commit_msg%"...
git commit -m "%commit_msg%"

echo [+] Pushing to GitHub (origin main)...
git push origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ===================================================
    echo             Successfully uploaded!
    echo ===================================================
) else (
    echo.
    echo ===================================================
    echo             Upload failed! Check error above.
    echo ===================================================
)

echo.
if "%~1"=="" pause
