@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ============================================
echo  Full Setup: Python 3.14.7 + Packages
echo ============================================
echo.

REM --- Require Administrator rights (needed for InstallAllUsers=1) ---
net session >nul 2>&1
if errorlevel 1 (
    echo ERROR: This script must be run as Administrator.
    echo Right-click this file and choose "Run as administrator".
    pause
    echo Close this window and re-run the script as Administrator.
    exit /b 1
)


:step1_download
echo ============================================
echo  Step 1: Checking / Downloading Python 3.14.7
echo ============================================

set URL=https://www.python.org/ftp/python/3.14.7/python-3.14.7-amd64.exe
set DEST=%USERPROFILE%\Downloads\python-3.14.7-amd64.exe

if exist "%DEST%" (
    set "SIZE=0"
    for %%F in ("%DEST%") do set "SIZE=%%~zF"
    if !SIZE! LSS 31700000 (
        echo Existing installer looks incomplete ^(!SIZE! bytes^), re-downloading...
        del "%DEST%"
    ) else (
        echo Python installer already exists at: %DEST%
        echo Skipping download...
        goto :step2_install
    )
)

echo Downloading to: %DEST%
curl -L -o "%DEST%" %URL%

if not exist "%DEST%" (
    echo ERROR: Download failed. Check your internet connection.
    pause
    exit /b 1
)

REM Re-check size after download to catch truncated/failed downloads
set "SIZE=0"
for %%F in ("%DEST%") do set "SIZE=%%~zF"
if !SIZE! LSS 31700000 (
    echo ERROR: Downloaded file looks incomplete ^(!SIZE! bytes^).
    echo Deleting bad file. Please re-run the script.
    del "%DEST%"
    pause
    exit /b 1
)

echo.
echo Download complete: %DEST%

:step2_install
echo.
echo ============================================
echo  Step 2: Checking / Installing Python 3.14.7
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
if "!IS_INSTALLED!"=="0" (
    reg query "HKLM\SOFTWARE\Python\PythonCore" >nul 2>&1 && set "IS_INSTALLED=1"
    reg query "HKCU\SOFTWARE\Python\PythonCore" >nul 2>&1 && set "IS_INSTALLED=1"
    py --version >nul 2>&1 && set "IS_INSTALLED=1"
)

REM If Python is found but NOT on PATH, try to repair it via the installer
REM instead of forcing the user to uninstall.
if "!IS_INSTALLED!"=="1" (
    if "!IS_ON_PATH!"=="0" (
        echo.
        echo Python appears to be installed but not on PATH.
        echo Attempting to repair by re-running the installer with PrependPath=1...

        if not exist "%INSTALLER%" (
            echo ERROR: Installer not found at %INSTALLER%
            echo Cannot repair automatically. Please uninstall Python manually and try again.
            pause
            exit /b 1
        )

        start /wait "" "%INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
        if errorlevel 1 (
            echo ERROR: Repair install failed. Please uninstall Python manually and try again.
            pause
            exit /b 1
        )

        call :RefreshPath
        python --version >nul 2>&1
        if errorlevel 1 (
            echo ERROR: Still cannot detect Python on PATH after repair.
            echo Please uninstall Python manually and try again.
            pause
            exit /b 1
        ) else (
            echo Repair successful. Python is now on PATH.
            goto :step3_requirements
        )
    ) else (
        echo Python is already installed and added to PATH.
        echo Skipping installation step.
        goto :step3_requirements
    )
)

REM If Python is not installed at all: install the downloaded installer
echo Python is not installed. Proceeding with installation...

if not exist "%INSTALLER%" (
    echo ERROR: Installer not found at %INSTALLER%
    echo Please ensure the installer was downloaded.
    pause
    exit /b 1
)

echo Running installer: %INSTALLER%
start /wait "" "%INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

REM Check the installer's own exit code before doing anything else
if errorlevel 1 (
    echo ERROR: Installer returned an error code. Installation failed.
    echo Try re-running this script as Administrator, or run the installer manually to see the error.
    pause
    exit /b 1
)

call :RefreshPath

echo.
echo Verifying installation...
python --version
if errorlevel 1 (
    echo ERROR: Python still not detected on PATH after install.
    echo Try closing and reopening cmd, then re-run this script.
    pause
    exit /b 1
) else (
    echo Python installed successfully and added to PATH.
)

:step3_requirements
echo.
echo ============================================
echo  Step 3: Installing packages from requirements.txt
echo ============================================

set REQ_FILE=%~dp0requirements.txt

REM Check Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found on PATH. Install Python first.
    pause
    exit /b 1
)

REM Check requirements.txt exists
if not exist "%REQ_FILE%" (
    echo ERROR: requirements.txt not found at %REQ_FILE%
    echo Make sure requirements.txt is in the same folder as this script.
    pause
    exit /b 1
)

echo Found requirements file: %REQ_FILE%
echo.

echo Upgrading pip...
python -m pip install --upgrade pip

echo.
echo ============================================
echo  Checking installed packages
echo ============================================

set "TO_INSTALL="

for /f "usebackq delims=" %%L in ("%REQ_FILE%") do (
    set "PKG=%%L"

    REM Strip any trailing carriage return (CRLF artifacts)
    if defined PKG (
        for /f "delims=" %%C in ("!PKG!") do set "PKG=%%C"
    )

    REM Skip blank lines and comment lines starting with #
    if defined PKG (
        if not "!PKG:~0,1!"=="#" (
            REM Strip any version specifier, e.g. numpy==2.1.0 -> numpy
            for /f "tokens=1 delims=<>=~ " %%P in ("!PKG!") do set "PKGNAME=%%P"

            python -m pip show !PKGNAME! >nul 2>&1
            if not errorlevel 1 (
                echo !PKGNAME! is already installed.
            ) else (
                echo !PKGNAME! is not installed. Queuing for installation...
                set "TO_INSTALL=!TO_INSTALL! !PKG!"
            )
        )
    )
)

echo.
if "!TO_INSTALL!"=="" (
    echo All packages already installed. Nothing to do.
) else (
    echo ============================================
    echo  Installing remaining packages
    echo ============================================
    python -m pip install !TO_INSTALL!

    if errorlevel 1 (
        echo.
        echo ERROR: Some packages failed to install. Check the output above.
        pause
        exit /b 1
    )
)

:done
echo.
echo ============================================
echo  All steps completed successfully.
echo ============================================
pause
exit /b 0

:RefreshPath
REM Pulls the updated PATH from registry into current session with expanded variables
set "SysPath="
set "UserPath="
for /f "skip=2 tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SysPath=%%B"
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "UserPath=%%B"
for /f "delims=" %%P in ('cmd /c "echo %SysPath%;%UserPath%"') do set "PATH=%%P"
goto :eof