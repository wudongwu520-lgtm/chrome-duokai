@echo off
:: Batch script: Generate multiple independent Chrome shortcuts

:: Set Chrome user data path (change to your path)
set "UserDataPath=D:\google\Chrome_UserData"

:: Set shortcut storage path (change to your path)
set "FilePath=D:\google\Chrome_ShortCuts"

:: Automatically create folders if they do not exist
if not exist "%UserDataPath%" mkdir "%UserDataPath%"
if not exist "%FilePath%" mkdir "%FilePath%"

:: Chrome executable path (only chrome.exe, no extra parameters)
set "TargetPath=C:\Program Files\Google\Chrome\Application\chrome.exe"

:: Chrome working directory
set "WorkingDirectory=C:\Program Files\Google\Chrome\Application"

:: Loop to create Chrome profiles from 1 to 10
for /l %%i in (1,1,10) do (
    call :CreateShortcut "%%i"
)

echo All Chrome shortcuts have been created successfully!
echo Press any key to continue . . .
pause >nul
exit


:CreateShortcut
:: %1 = profile number
set "Profile=%~1"
set "ShortcutFile=%FilePath%\Chrome_%Profile%.lnk"
set "Arguments=--user-data-dir=%UserDataPath%\%Profile%"

:: Create temporary VBS file
set "VBSFile=%temp%\CreateShortcut.vbs"
> "%VBSFile%" echo Set oWS = WScript.CreateObject("WScript.Shell")
>>"%VBSFile%" echo sLinkFile = "%ShortcutFile%"
>>"%VBSFile%" echo Set oLink = oWS.CreateShortcut(sLinkFile)
>>"%VBSFile%" echo oLink.TargetPath = "%TargetPath%"
>>"%VBSFile%" echo oLink.Arguments = "%Arguments%"
>>"%VBSFile%" echo oLink.WorkingDirectory = "%WorkingDirectory%"
>>"%VBSFile%" echo oLink.Description = "Chrome Profile %Profile%"
>>"%VBSFile%" echo oLink.Save

:: Run the VBS
cscript //nologo "%VBSFile%"

:: Delete the VBS file
del "%VBSFile%" >nul 2>&1
exit /b
