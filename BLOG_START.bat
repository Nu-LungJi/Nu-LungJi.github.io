@echo off
chcp 65001 >nul
setlocal EnableExtensions DisableDelayedExpansion
cd /d "%~dp0"
if errorlevel 1 exit /b 1
set "CURRENT="
set "STASH_ID="
set "OLD_STASH="
set "TOP_STASH="
set "TIMESTAMP="
set "POSTS_URI="
set "STATUS_FILE=%TEMP%\BLOG_START-%RANDOM%-%RANDOM%.tmp"

echo ==========================================
echo   Nu-LungJi Blog - START
echo ==========================================
echo.

:: Git 저장소와 현재 브랜치 확인
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 현재 폴더가 Git 작업 저장소가 아니거나 Git을 실행할 수 없습니다.
    goto :failed
)
for /f "delims=" %%A in ('git branch --show-current') do set "CURRENT=%%A"
if not defined CURRENT (
    echo [ERROR] 현재 브랜치를 확인할 수 없습니다. Detached HEAD 상태를 확인해주세요.
    goto :failed
)
echo 현재 브랜치: %CURRENT%
echo.

:: 진행 중인 병합 또는 rebase가 있으면 먼저 해결해야 합니다.
for %%G in (MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD rebase-merge rebase-apply sequencer) do (
    for /f "delims=" %%P in ('git rev-parse --git-path %%G') do (
        if exist "%%P" (
            echo [ERROR] 진행 중인 Git 작업이 있습니다. 먼저 완료하거나 취소해주세요.
            goto :failed
        )
    )
)
if not exist "_posts\" (
    echo [ERROR] 블로그 글 폴더 _posts가 없습니다.
    goto :failed
)

:: 기존과 동일하게 실행 배치파일과 Obsidian 설정은 블로그 변경에서 제외합니다.
:: [o]는 o와 같은 문자입니다. 디렉터리를 glob으로 표현하면 stash 내부의
:: git add가 추적 중이면서 ignored인 .obsidian을 명시적 추가 경로로 오인하지 않습니다.
git status --porcelain --untracked-files=all -- . ":!BLOG_START.bat" ":!BLOG_PUBLISH.bat" ":(exclude,glob).[o]bsidian/**" >"%STATUS_FILE%"
if errorlevel 1 (
    echo [ERROR] 변경사항 확인 실패
    goto :failed
)
for %%A in ("%STATUS_FILE%") do if %%~zA==0 goto :sync_master

echo 미커밋 블로그 변경사항이 있습니다:
git status --short -- . ":!BLOG_START.bat" ":!BLOG_PUBLISH.bat" ":(exclude,glob).[o]bsidian/**"
echo.
choice /c YN /n /m "이 변경사항을 최신 master에 적용할까요? [Y/N]: "
if errorlevel 2 goto :cancelled
if errorlevel 1 goto :save_changes
goto :cancelled

:save_changes
echo 변경사항과 새 파일을 stash에 보관합니다...
for /f "delims=" %%A in ('git rev-parse --verify refs/stash 2^>nul') do set "OLD_STASH=%%A"
git stash push --include-untracked -m "BLOG_START: %CURRENT%" -- . ":!BLOG_START.bat" ":!BLOG_PUBLISH.bat" ":(exclude,glob).[o]bsidian/**"
set "STASH_EXIT=%ERRORLEVEL%"
:: 저장 후 정리 단계에서 실패해도 새 stash의 ID를 기록합니다.
for /f "delims=" %%A in ('git rev-parse --verify refs/stash 2^>nul') do set "STASH_ID=%%A"
if "%STASH_ID%"=="%OLD_STASH%" set "STASH_ID="
if not "%STASH_EXIT%"=="0" (
    echo [ERROR] stash 처리 실패. 작업 폴더와 보관된 stash를 확인해주세요.
    goto :failed
)
if not defined STASH_ID (
    echo [ERROR] 저장한 stash를 확인할 수 없습니다.
    goto :failed
)

:sync_master
echo.
echo [1/5] master 브랜치로 이동합니다...
git switch master
if errorlevel 1 (
    echo [ERROR] master 이동 실패
    goto :failed
)

echo.
echo [2/5] 최신 master를 가져옵니다...
:: master 이력이 갈라졌으면 자동 rebase나 merge 없이 중단합니다.
git pull --ff-only origin master
if errorlevel 1 (
    echo [ERROR] master 업데이트 실패. 네트워크와 로컬 master 이력을 확인해주세요.
    goto :failed
)

echo.
echo [3/5] 보관한 변경사항을 최신 master에 적용합니다...
if not defined STASH_ID goto :create_branch
:: apply 성공 후에만 stash를 삭제합니다. 충돌 시 원본은 그대로 보존됩니다.
git stash apply "%STASH_ID%"
if errorlevel 1 (
    echo [ERROR] stash 적용 실패 또는 충돌이 발생했습니다.
    echo 현재 master의 충돌을 해결한 후 작업 브랜치를 만들어주세요.
    echo 같은 stash를 다시 적용하지 마세요. 일부 변경은 이미 적용되었을 수 있습니다.
    goto :failed
)

:create_branch
echo.
echo [4/5] 새 작업 브랜치를 생성합니다...
for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss-fff"') do set "TIMESTAMP=%%A"
if not defined TIMESTAMP (
    echo [ERROR] 브랜치 생성용 시간을 확인할 수 없습니다.
    goto :failed
)
set "BRANCH=work/%COMPUTERNAME%-%TIMESTAMP%"
git switch -c "%BRANCH%"
if errorlevel 1 (
    echo [ERROR] 작업 브랜치 생성 실패. 적용된 변경사항은 현재 브랜치에 남아 있습니다.
    goto :failed
)

:: 다른 stash를 삭제하지 않도록 이번 stash가 맨 위에 있는지 확인합니다.
if not defined STASH_ID goto :open_obsidian
for /f "delims=" %%A in ('git rev-parse --verify refs/stash 2^>nul') do set "TOP_STASH=%%A"
if not "%TOP_STASH%"=="%STASH_ID%" (
    echo [INFO] stash 목록이 바뀌어 백업 stash를 그대로 남깁니다: %STASH_ID%
    goto :open_obsidian
)
git stash drop "stash@{0}"
if errorlevel 1 echo [INFO] 작업은 복원되었지만 백업 stash 삭제에는 실패했습니다.

:open_obsidian
echo.
echo [5/5] Obsidian에서 _posts 폴더를 엽니다...
set "BLOG_POSTS_PATH=%CD%\_posts"
for /f "delims=" %%A in ('powershell -NoProfile -Command "'obsidian://open?path=' + [Uri]::EscapeDataString($env:BLOG_POSTS_PATH)"') do set "POSTS_URI=%%A"
if not defined POSTS_URI (
    echo [ERROR] Obsidian 경로 생성 실패. 작업 브랜치는 생성되었습니다.
    goto :failed
)
start "" "C:\Users\pc\AppData\Local\Programs\Obsidian\Obsidian.exe" "obsidian://open?vault=_posts"
if errorlevel 1 (
    echo [ERROR] Obsidian 실행 요청 실패. 작업 브랜치는 생성되었습니다.
    goto :failed
)
if exist "%STATUS_FILE%" del /q "%STATUS_FILE%"
echo.
echo ==========================================
echo 작업 준비 완료
echo Branch: %BRANCH%
echo 글 작성 후 BLOG_PUBLISH.bat을 실행해주세요.
echo ==========================================
timeout /t 3 /nobreak >nul
exit /b 0

:cancelled
if exist "%STATUS_FILE%" del /q "%STATUS_FILE%"
echo 취소했습니다. 브랜치와 변경사항을 그대로 유지합니다.
exit /b 0

:failed
if exist "%STATUS_FILE%" del /q "%STATUS_FILE%"
if defined STASH_ID (
    echo.
    echo 보관한 stash ID: %STASH_ID%
    echo git status와 git stash list를 확인한 뒤 복구해주세요.
)
pause
exit /b 1
