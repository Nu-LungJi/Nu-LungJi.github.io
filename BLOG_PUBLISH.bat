@echo off
chcp 65001 > nul
cd /d "%~dp0"
setlocal EnableDelayedExpansion


echo ==========================================
echo   Nu-LungJi Blog - PUBLISH
echo ==========================================
echo.


:: Git 확인
git rev-parse --is-inside-work-tree >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Git 저장소가 아닙니다.
    pause
    exit /b 1
)



:: 현재 브랜치 확인
for /f "delims=" %%A in ('git branch --show-current') do set BRANCH=%%A


echo 현재 브랜치:
echo %BRANCH%
echo.



:: master 방지
if /I "%BRANCH%"=="master" (

    echo [ERROR] master 브랜치입니다.

    echo BLOG_START.bat 실행 후 작업해주세요.

    pause
    exit /b 1
)



:: work 브랜치 확인

echo %BRANCH% | findstr /b "work/" >nul

if errorlevel 1 (

    echo [ERROR] 작업 브랜치가 아닙니다.

    echo 현재:
    echo %BRANCH%

    pause
    exit /b 1
)



:: 변경사항 확인

git status --porcelain > temp_status.txt


for %%A in (temp_status.txt) do (

    if %%~zA==0 (

        echo 변경된 파일이 없습니다.

        del temp_status.txt

        pause
        exit /b 0

    )

)


del temp_status.txt



echo.
echo ==========================================
echo 변경 파일
echo ==========================================

git status --short

echo.


set /p MESSAGE=Commit 메시지를 입력하세요:



if "%MESSAGE%"=="" (

    echo Commit 메시지가 필요합니다.

    pause
    exit /b 1

)



echo.
echo [1/3] Stage...

git add -A



echo.
echo [2/3] Commit...

git commit -m "%MESSAGE%"



if errorlevel 1 (

    echo Commit 실패

    pause

    exit /b 1

)



echo.
echo [3/3] Push...


git push -u origin "%BRANCH%"



if errorlevel 1 (

    echo Push 실패

    pause

    exit /b 1

)



echo.
echo ==========================================
echo Publish 완료
echo ==========================================


start "" "https://github.com/Nu-LungJi/Nu-LungJi.github.io/compare/master...%BRANCH%?expand=1"


echo.
echo Pull Request 생성 화면이 열렸습니다.

pause

exit /b 0