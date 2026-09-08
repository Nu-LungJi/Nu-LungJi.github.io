@echo off
chcp 65001 > nul
cd /d "%~dp0"
setlocal EnableDelayedExpansion

echo ==========================================
echo   LungJi Lab - PUBLISH
echo ==========================================
echo.

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git 저장소가 아닙니다.
    pause
    exit /b 1
)

:: 변경사항 확인
git status --porcelain > "%TEMP%\blog_status.txt"

for %%A in ("%TEMP%\blog_status.txt") do (
    if %%~zA==0 (
        echo 변경된 파일이 없습니다.
        del "%TEMP%\blog_status.txt"
        pause
        exit /b 0
    )
)

del "%TEMP%\blog_status.txt"

echo 변경된 파일:
echo ------------------------------------------
git status --short
echo ------------------------------------------
echo.

:: 현재 브랜치 확인
for /f "delims=" %%A in ('git branch --show-current') do set CURRENT_BRANCH=%%A

if /I not "%CURRENT_BRANCH%"=="master" (
    echo [ERROR] 현재 브랜치가 master가 아닙니다.
    echo 현재 브랜치: %CURRENT_BRANCH%
    echo.
    echo 새 Publish는 master에서 시작해야 합니다.
    pause
    exit /b 1
)

:: 원격 상태 확인
echo GitHub 상태 확인 중...
git fetch origin

if errorlevel 1 (
    echo [ERROR] GitHub Fetch 실패
    pause
    exit /b 1
)

:: 새 브랜치 이름 생성
for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd"') do set TIMESTAMP=%%A

set BRANCH=publish/%COMPUTERNAME%-%TIMESTAMP%

echo.
echo 새 Publish 브랜치 생성:
echo %BRANCH%
echo.

git switch -c "%BRANCH%"

if errorlevel 1 (
    echo [ERROR] 브랜치 생성 실패
    pause
    exit /b 1
)

:: Commit 메시지
set /p MESSAGE=Commit 메시지를 입력하세요: 

if "%MESSAGE%"=="" (
    echo [ERROR] Commit 메시지가 비어 있습니다.
    pause
    exit /b 1
)

echo.
echo [1/3] Commit...
git add -A
git commit -m "%MESSAGE%"

if errorlevel 1 (
    echo [ERROR] Commit 실패
    pause
    exit /b 1
)

echo.
echo [2/3] Branch Push...
git push -u origin "%BRANCH%"

if errorlevel 1 (
    echo [ERROR] Push 실패
    pause
    exit /b 1
)

echo.
echo [3/3] Pull Request 페이지 열기...

start "" "https://github.com/Nu-LungJi/Nu-LungJi.github.io/compare/main...%BRANCH%?expand=1"

echo.
echo ==========================================
echo Publish 준비 완료
echo.
echo Branch:
echo %BRANCH%
echo.
echo GitHub에서 Diff와 Conflict를 확인한 뒤
echo Pull Request를 생성하고 Merge하세요.
echo ==========================================
echo.

pause