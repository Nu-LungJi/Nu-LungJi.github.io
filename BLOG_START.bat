@echo off
chcp 65001 > nul
cd /d "%~dp0"
setlocal

echo ==========================================
echo   Nu-LungJi Blog - START
echo ==========================================
echo.

:: Git 저장소인지 확인
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 현재 폴더가 Git 저장소가 아닙니다.
    pause
    exit /b 1
)

:: 로컬 변경사항 확인
for /f %%A in ('git status --porcelain') do (
    echo [ERROR] 아직 Commit되지 않은 변경사항이 있습니다.
    echo.
    git status --short
    echo.
    echo BLOG_PUBLISH.bat으로 작업을 먼저 정리해주세요.
    pause
    exit /b 1
)

echo [1/4] main 브랜치로 이동합니다...
git switch main

if errorlevel 1 (
    echo.
    echo [ERROR] main 브랜치로 이동하지 못했습니다.
    pause
    exit /b 1
)

echo.
echo [2/4] GitHub의 최신 main을 가져옵니다...
git pull --rebase origin main

if errorlevel 1 (
    echo.
    echo [ERROR] Git Pull에 실패했습니다.
    echo 위 오류를 확인해주세요.
    pause
    exit /b 1
)

echo.
echo [3/4] 새 작업 브랜치를 생성합니다...

for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set TIMESTAMP=%%A

set BRANCH=work/%COMPUTERNAME%-%TIMESTAMP%

git switch -c "%BRANCH%"

if errorlevel 1 (
    echo.
    echo [ERROR] 작업 브랜치를 만들지 못했습니다.
    pause
    exit /b 1
)

echo.
echo 생성된 브랜치:
echo %BRANCH%

echo.
echo [4/4] Obsidian을 실행합니다...
start "" "obsidian://open?path=%CD%"

echo.
echo ==========================================
echo 작업 준비 완료
echo.
echo Branch:
echo %BRANCH%
echo ==========================================

timeout /t 3 /nobreak > nul
exit /b 0