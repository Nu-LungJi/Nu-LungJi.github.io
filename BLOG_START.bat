@echo off
chcp 65001 > nul
cd /d "%~dp0"
setlocal

set BASE_BRANCH=master

echo ==========================================
echo   Nu-LungJi Blog - START
echo ==========================================
echo.

:: Git 저장소 확인
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 현재 폴더가 Git 저장소가 아닙니다.
    pause
    exit /b 1
)

:: 로컬 변경사항 확인
git status --porcelain > "%TEMP%\blog_status.txt"

for %%A in ("%TEMP%\blog_status.txt") do (
    if not %%~zA==0 (
        echo [ERROR] 아직 정리되지 않은 변경사항이 있습니다.
        echo.
        git status --short
        echo.
        echo 먼저 BLOG_PUBLISH.bat을 실행해주세요.
        del "%TEMP%\blog_status.txt"
        pause
        exit /b 1
    )
)

del "%TEMP%\blog_status.txt"

echo [1/3] %BASE_BRANCH% 브랜치로 이동합니다...
git switch %BASE_BRANCH%

if errorlevel 1 (
    echo.
    echo [ERROR] %BASE_BRANCH% 브랜치로 이동하지 못했습니다.
    pause
    exit /b 1
)

echo.
echo [2/3] GitHub 최신 내용을 가져옵니다...
git pull --rebase origin %BASE_BRANCH%

if errorlevel 1 (
    echo.
    echo [ERROR] Git Pull에 실패했습니다.
    pause
    exit /b 1
)

echo.
echo [3/3] Obsidian 실행...
start "" "obsidian://open?path=%CD%"

echo.
echo ==========================================
echo 작업 준비 완료
echo 현재 브랜치: %BASE_BRANCH%
echo ==========================================

timeout /t 2 /nobreak > nul
exit /b 0