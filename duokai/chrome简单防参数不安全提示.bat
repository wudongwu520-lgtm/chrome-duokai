@echo off
:: Batch script: Generate multiple Chrome shortcuts with unique fingerprints

:: Set Chrome user data path (change to your path)
set "UserDataPath=D:\google\Chrome_UserData"

:: Set shortcut storage path (change to your path)
set "FilePath=D:\google\Chrome_ShortCuts"

:: Automatically create folders if they do not exist
if not exist "%UserDataPath%" mkdir "%UserDataPath%"
if not exist "%FilePath%" mkdir "%FilePath%"

:: Chrome executable path
set "TargetPath=C:\Program Files\Google\Chrome\Application\chrome.exe"

:: Chrome working directory
set "WorkingDirectory=C:\Program Files\Google\Chrome\Application"

:: Define different fingerprints for each profile
:: Format: "user-agent|accept-language|window-size|device-scale-factor|other-flags"
set "Fingerprint1=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36|en-US,en;q=0.9|1920,1080|1|--disable-blink-features=AutomationControlled"
set "Fingerprint2=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36|en-GB,en-US;q=0.8,en;q=0.6|1366,768|1|--disable-blink-features=AutomationControlled --disable-extensions"
set "Fingerprint3=Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36|de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7|1536,864|1.25|--disable-blink-features=AutomationControlled"
set "Fingerprint4=Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36|fr-FR,fr;q=0.9,en;q=0.8|1280,720|1|--disable-blink-features=AutomationControlled --no-first-run"
set "Fingerprint5=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36|es-ES,es;q=0.9,en;q=0.8|1440,900|1|--disable-blink-features=AutomationControlled"
set "Fingerprint6=Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36|ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7|1600,900|1|--disable-blink-features=AutomationControlled --disable-plugins-discovery"
set "Fingerprint7=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36|zh-CN,zh;q=0.9,en;q=0.8|1024,768|1|--disable-blink-features=AutomationControlled"
set "Fingerprint8=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36|ja-JP,ja;q=0.9,en;q=0.8|1920,1080|1.5|--disable-blink-features=AutomationControlled --disable-sync"
set "Fingerprint9=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36|pt-BR,pt;q=0.9,en;q=0.8|1366,768|1|--disable-blink-features=AutomationControlled"
set "Fingerprint10=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.128 Safari/537.36|it-IT,it;q=0.9,en;q=0.8|1280,800|1|--disable-blink-features=AutomationControlled --disable-component-update"

:: Loop to create Chrome profiles from 1 to 20
for /l %%i in (1,1,20) do (
    call :CreateShortcut "%%i"
)

echo All Chrome fingerprint shortcuts have been created successfully!
echo Press any key to continue . . .
pause >nul
exit


:CreateShortcut
:: %1 = profile number
set "Profile=%~1"
set "ShortcutFile=%FilePath%\Chrome_Fingerprint_%Profile%.lnk"

:: Get the fingerprint for this profile
call set "Fingerprint=%%Fingerprint%Profile%%%"

:: Extract individual fingerprint components
for /f "tokens=1-5 delims=|" %%a in ("%Fingerprint%") do (
    set "UserAgent=%%a"
    set "AcceptLanguage=%%b"
    set "WindowSize=%%c"
    set "DeviceScale=%%d"
    set "OtherFlags=%%e"
)

:: Build command line arguments with fingerprint features (single line to avoid issues)
set "Arguments=--user-data-dir=%UserDataPath%\Fingerprint_%Profile% --user-agent=""%UserAgent%"" --accept-language=""%AcceptLanguage%"" --window-size=%WindowSize% --device-scale-factor=%DeviceScale% %OtherFlags%"

:: Create temporary VBS file (using echo without line continuation to prevent ^ issues)
set "VBSFile=%temp%\CreateShortcut_%Profile%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBSFile%"
echo sLinkFile = "%ShortcutFile%" >> "%VBSFile%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBSFile%"
echo oLink.TargetPath = "%TargetPath%" >> "%VBSFile%"
echo oLink.Arguments = "%Arguments%" >> "%VBSFile%"
echo oLink.WorkingDirectory = "%WorkingDirectory%" >> "%VBSFile%"
echo oLink.Description = "Chrome Fingerprint Profile %Profile%" >> "%VBSFile%"
echo oLink.Save >> "%VBSFile%"

:: Run the VBS to create shortcut
cscript //nologo "%VBSFile%"

:: Delete the VBS file
del "%VBSFile%" >nul 2>&1
exit /b
