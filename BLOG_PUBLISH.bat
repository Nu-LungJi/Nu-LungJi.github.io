@echo off
chcp 65001 > nul
cd /d "%~dp0"
setlocal EnableDelayedExpansion

set BASE_BRANCH=master

echo ==========================================
echo   Nu-LungJi Blog - PUBLISH
echo ==========================================
echo.

:: Git 저장소 확인
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 현재 폴더가 Git 저장소가 아닙니다.
    pause
    exit /b 1
)

:: 현재 브랜치 확인
for /f "delims=" %%A in ('git branch --show-current') do set CURRENT_BRANCH=%%A

echo 현재 브랜치: %CURRENT_BRANCH%
echo.

:: 반드시 master에서 Publish 시작
if /I not "%CURRENT_BRANCH%"=="%BASE_BRANCH%" (
    echo [ERROR] 현재 브랜치가 %BASE_BRANCH%가 아닙니다.
    echo.
    echo 현재 브랜치:
    echo %CURRENT_BRANCH%
    echo.
    echo BLOG_START.bat을 먼저 실행해주세요.
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

echo ==========================================
echo 변경된 파일
echo ==========================================
git status --short
echo ==========================================
echo.

:: 원격 정보 최신화
echo [1/6] GitHub 상태 확인 중...
git fetch origin

if errorlevel 1 (
    echo.
    echo [ERROR] Git Fetch 실패
    pause
    exit /b 1
)

:: Publish 브랜치 생성
for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set TIMESTAMP=%%A

set PUBLISH_BRANCH=publish-%COMPUTERNAME%-%TIMESTAMP%

echo.
echo [2/6] 새 Publish 브랜치 생성...
echo %PUBLISH_BRANCH%
echo.

git switch -c "%PUBLISH_BRANCH%"

if errorlevel 1 (
    echo.
    echo [ERROR] 브랜치 생성 실패
    pause
    exit /b 1
)

:: Commit 메시지
set /p MESSAGE=Commit 메시지를 입력하세요: 

if "%MESSAGE%"=="" (
    echo.
    echo [ERROR] Commit 메시지를 입력해야 합니다.
    echo %BASE_BRANCH% 브랜치로 복귀합니다.
    git switch %BASE_BRANCH%
    pause
    exit /b 1
)

echo.
echo [3/6] 변경사항 Commit...
git add -A

if errorlevel 1 (
    echo.
    echo [ERROR] git add 실패
    pause
    exit /b 1
)

git commit -m "%MESSAGE%"

if errorlevel 1 (
    echo.
    echo [ERROR] Commit 실패
    pause
    exit /b 1
)

echo.
echo [4/6] Publish 브랜치를 GitHub에 Push...
git push -u origin "%PUBLISH_BRANCH%"

if errorlevel 1 (
    echo.
    echo [ERROR] Push 실패
    echo 현재 Commit은 %PUBLISH_BRANCH%에 안전하게 남아 있습니다.
    pause
    exit /b 1
)

echo.
echo [5/6] Pull Request 페이지를 엽니다...

start "" "https://github.com/Nu-LungJi/Nu-LungJi.github.io/compare/%BASE_BRANCH%...%PUBLISH_BRANCH%?expand=1"

echo.
echo [6/6] 로컬을 %BASE_BRANCH% 브랜치로 복귀합니다...

git switch %BASE_BRANCH%

if errorlevel 1 (
    echo.
    echo [WARNING] %BASE_BRANCH% 브랜치 자동 복귀에 실패했습니다.
    echo PR용 브랜치는 정상적으로 Push되었습니다.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo PUBLISH 완료
echo ==========================================
echo.
echo PR 브랜치:
echo %PUBLISH_BRANCH%
echo.
echo 로컬 현재 브랜치:
echo %BASE_BRANCH%
echo.
echo 브라우저에서:
echo   1. 변경사항 확인
echo   2. Create Pull Request
echo   3. Merge
echo.
echo 다음 작업 때 BLOG_START.bat을 실행하면
echo 최신 %BASE_BRANCH%를 다시 Pull합니다.
echo ==========================================
echo.

pause
exit /b 0