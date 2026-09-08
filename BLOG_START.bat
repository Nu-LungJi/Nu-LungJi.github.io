@echo off
chcp 65001 > nul
cd /d "%~dp0"

echo ==========================================
echo   LungJi Lab - START
echo ==========================================
echo.

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git 저장소가 아닙니다.
    pause
    exit /b 1
)

:: 작업 중인 변경사항이 있으면 중단
for /f %%A in ('git status --porcelain') do (
    echo [ERROR] 아직 정리되지 않은 변경사항이 있습니다.
    echo.
    git status --short
    echo.
    echo 먼저 BLOG_PUBLISH.bat을 실행해주세요.
    pause
    exit /b 1
)

echo [1/2] main 최신화...
git switch main

if errorlevel 1 (
    echo [ERROR] main 이동 실패
    pause
    exit /b 1
)

git pull --rebase origin main

if errorlevel 1 (
    echo [ERROR] Git Pull 실패
    pause
    exit /b 1
)

echo.
echo [2/2] Obsidian 실행...
start "" "obsidian://open?path=%CD%"

exit