@echo off
echo ============================================
echo  Step 2: Installing Python 3.14.7
echo ============================================

set INSTALLER=%USERPROFILE%\Downloads\python-3.14.7-amd64.exe

set "IS_INSTALLED=0"
set "IS_ON_PATH=0"

REM Check if Python command is accessible on PATH
python --version >nul 2>&1
if not errorlevel 1 (
    set "IS_INSTALLED=1"
    set "IS_ON_PATH=1"
)

REM Check Registry and py launcher if not already detected on PATH
if "%IS_INSTALLED%"=="0" (
    reg query "HKLM\SOFTWARE\Python\PythonCore" >nul 2>&1 && set "IS_INSTALLED=1"
    reg query "HKCU\SOFTWARE\Python\PythonCore" >nul 2>&1 && set "IS_INSTALLED=1"
    py --version >nul 2>&1 && set "IS_INSTALLED=1"
)

REM If Python is installed:
if "%IS_INSTALLED%"=="1" (
    if "%IS_ON_PATH%"=="0" (
        echo.
        echo python not installed as path, uninstall python and try again
        pause
        exit /b 1
    ) else (
        echo Python is already installed and added to PATH.
        echo Skipping installation step.
        pause
        exit /b 0
    )
)

REM If Python is not installed: install the downloaded installer
echo Python is not installed. Proceeding with installation...

if not exist "%INSTALLER%" (
    echo ERROR: Installer not found at %INSTALLER%
    echo Run download_python.bat first.
    pause
    exit /b 1
)

echo Running installer: %INSTALLER%
start /wait "" "%INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

REM Refresh PATH in this session so python is usable immediately
for /f "skip=2 tokens=3*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path') do set "SysPath=%%A %%B"
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "UserPath=%%A %%B"
set "PATH=%SysPath%;%UserPath%"

echo.
echo Verifying installation...
python --version
if errorlevel 1 (
    echo WARNING: Python not detected on PATH yet.
    echo You may need to close and reopen cmd before running install_requirement.bat.
) else (
    echo Python installed successfully and added to PATH.
)

pause
exit /b 0