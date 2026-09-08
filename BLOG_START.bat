@echo off
chcp 65001 > nul
cd /d "%~dp0"
setlocal EnableDelayedExpansion

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


:: 현재 브랜치 확인
for /f "delims=" %%A in ('git branch --show-current') do set CURRENT=%%A


echo 현재 브랜치:
echo %CURRENT%
echo.

:: 블로그 작업 변경사항 확인
for /f "delims=" %%A in ('git status --porcelain -- . ":!BLOG_START.bat" ":!BLOG_PUBLISH.bat" ":!.obsidian"') do (

    echo.
    echo [ERROR] 블로그 작업 중 Commit되지 않은 변경사항이 있습니다.
    echo.
    git status --short
    echo.
    echo 먼저 작업을 정리해주세요.
    pause
    exit /b 1

)

:: master 이동
echo [1/4] master 브랜치로 이동합니다...

git switch master

if errorlevel 1 (
    echo [ERROR] master 이동 실패
    pause
    exit /b 1
)


echo.


:: 최신 master 가져오기
echo [2/4] GitHub 최신 master 동기화...

git pull --rebase origin master

if errorlevel 1 (
    echo [ERROR] master 업데이트 실패
    pause
    exit /b 1
)


echo.


:: 브랜치 생성
echo [3/4] 새 작업 브랜치 생성...


for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set TIMESTAMP=%%A


set BRANCH=work/%COMPUTERNAME%-%TIMESTAMP%


git switch -c "%BRANCH%"


if errorlevel 1 (
    echo [ERROR] 작업 브랜치 생성 실패
    pause
    exit /b 1
)


echo.
echo 생성된 브랜치:
echo %BRANCH%
echo.



:: Obsidian 실행
echo [4/4] Obsidian 실행...


start "" "obsidian://open?path=%CD%"


echo.
echo ==========================================
echo 작업 준비 완료
echo.
echo Branch:
echo %BRANCH%
echo.
echo 이제 글 작성 후 BLOG_PUBLISH.bat 실행
echo ==========================================


timeout /t 3 /nobreak > nul

exit /b 0