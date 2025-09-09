@echo off
:: Batch script: Generate multiple independent Chrome shortcuts with basic fingerprint variation

:: Set Chrome user data path
set "UserDataPath=D:\google\Chrome_UserData"

:: Set shortcut storage path
set "FilePath=D:\google\Chrome_ShortCuts"

:: Auto create folders if not exist
if not exist "%UserDataPath%" mkdir "%UserDataPath%"
if not exist "%FilePath%" mkdir "%FilePath%"

:: Chrome executable path
set "TargetPath=C:\Program Files\Google\Chrome\Application\chrome.exe"

:: Check if Chrome exists
if not exist "%TargetPath%" (
    echo ERROR: Chrome executable not found at %TargetPath%
    pause
    exit /b 1
)

:: Chrome working directory
set "WorkingDirectory=C:\Program Files\Google\Chrome\Application"

:: Enable delayed expansion
setlocal enabledelayedexpansion

:: Reset counter
set i=0

:: Define arrays of parameters
set langs=en-US zh-CN fr-FR de-DE ja-JP
set sizes=1280,720 1366,768 1600,900 1920,1080
set uas="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

:: Convert lists into arrays - LANGUAGES
for %%a in (%langs%) do (
    set /a i+=1
    set "lang[!i!]=%%a"
)
set langCount=!i!

:: Reset counter for sizes
set i=0
for %%a in (%sizes%) do (
    set /a i+=1
    set "size[!i!]=%%a"
)
set sizeCount=!i!

:: Reset counter for user agents
set i=0
for %%a in (%uas%) do (
    set /a i+=1
    set "ua[!i!]=%%~a"
)
set uaCount=!i!

echo Found:
echo   Languages: !langCount!
echo   Window Sizes: !sizeCount!
echo   User Agents: !uaCount!

:: Loop to create 10 Chrome shortcuts
for /l %%i in (1,1,10) do (
    set /a l=^(%%i - 1^) %% !langCount! + 1
    set /a s=^(%%i - 1^) %% !sizeCount! + 1
    set /a u=^(%%i - 1^) %% !uaCount! + 1

    set "ShortcutName=Chrome_%%i"
    set "UserDataDir=%UserDataPath%\%%i"
    set "Arguments=--user-data-dir=!UserDataDir! --lang=!lang[%l%]! --window-size=!size[%s%]! --user-agent=!ua[%u%]!"

    call :CreateShortcut "%FilePath%\!ShortcutName!.lnk" "%TargetPath%" "!Arguments!" "%WorkingDirectory%" "Chrome Profile %%i"
    
    :: Optional: Echo progress
    echo Created shortcut !ShortcutName!: Lang=!lang[%l%]!, Size=!size[%s%]!, UA Index=!u!
)

echo.
echo All 10 Chrome shortcuts have been created successfully!
echo Press any key to continue...
pause >nul
exit /b


:: Function: CreateShortcut
:CreateShortcut
:: Parameters: %1=Shortcut path, %2=Target exe, %3=Arguments, %4=Working dir, %5=Description
set "shortcut=%~1"
set "target=%~2"
set "args=%~3"
set "workdir=%~4"
set "desc=%~5"

set "VBSFile=%temp%\CreateShortcut_%random%.vbs"
> "%VBSFile%" echo Set oWS = WScript.CreateObject("WScript.Shell")
>>"%VBSFile%" echo sLinkFile = "%shortcut%"
>>"%VBSFile%" echo Set oLink = oWS.CreateShortcut(sLinkFile)
>>"%VBSFile%" echo oLink.TargetPath = "%target%"
>>"%VBSFile%" echo oLink.Arguments = "%args%"
>>"%VBSFile%" echo oLink.WorkingDirectory = "%workdir%"
>>"%VBSFile%" echo oLink.Description = "%desc%"
>>"%VBSFile%" echo oLink.IconLocation = "%target%,0"
>>"%VBSFile%" echo oLink.Save

cscript //nologo "%VBSFile%"
if errorlevel 1 (
    echo [ERROR] Failed to create shortcut: %shortcut%
)
del "%VBSFile%" >nul 2>&1
exit /b