@echo off
chcp 65001 > nul
cd /d "%~dp0"
setlocal EnableDelayedExpansion

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
for /f "delims=" %%A in ('git branch --show-current') do set BRANCH=%%A

if "%BRANCH%"=="" (
    echo [ERROR] 현재 브랜치를 확인할 수 없습니다.
    pause
    exit /b 1
)

if /I "%BRANCH%"=="main" (
    echo [ERROR] 현재 main 브랜치입니다.
    echo.
    echo main에는 직접 Publish하지 않습니다.
    echo BLOG_START.bat을 먼저 실행해주세요.
    pause
    exit /b 1
)

echo 현재 작업 브랜치:
echo %BRANCH%
echo.

:: 변경사항 확인
for /f %%A in ('git status --porcelain') do goto HAS_CHANGES

echo 변경된 파일이 없습니다.
echo.
pause
exit /b 0


:HAS_CHANGES

echo ==========================================
echo 변경된 파일
echo ==========================================
git status --short
echo.

set /p MESSAGE=Commit 메시지를 입력하세요: 

if "%MESSAGE%"=="" (
    echo.
    echo [ERROR] Commit 메시지를 입력해야 합니다.
    pause
    exit /b 1
)

echo.
echo [1/4] 변경사항을 Stage 합니다...
git add -A

if errorlevel 1 (
    echo [ERROR] git add 실패
    pause
    exit /b 1
)

echo.
echo [2/4] Commit 합니다...
git commit -m "%MESSAGE%"

if errorlevel 1 (
    echo [ERROR] Commit 실패
    pause
    exit /b 1
)

echo.
echo [3/4] GitHub에 작업 브랜치를 Push 합니다...
git push -u origin "%BRANCH%"

if errorlevel 1 (
    echo.
    echo [ERROR] Push에 실패했습니다.
    echo main에는 아무 변경도 적용되지 않았습니다.
    pause
    exit /b 1
)

echo.
echo [4/4] GitHub Pull Request 화면을 엽니다...

start "" "https://github.com/Nu-LungJi/Nu-LungJi.github.io/compare/main...%BRANCH%?expand=1"

echo.
echo ==========================================
echo Push 완료
echo ==========================================
echo.
echo Branch:
echo %BRANCH%
echo.
echo 브라우저에서 변경사항을 검토한 뒤
echo Create Pull Request를 눌러주세요.
echo.
echo PR Merge 전까지 main에는 반영되지 않습니다.
echo ==========================================
echo.

pause
exit /b 0