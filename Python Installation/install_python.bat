@echo off
echo ============================================
echo  Step 2: Installing Python 3.14.7
echo ============================================

set INSTALLER=%USERPROFILE%\Downloads\python-3.14.7-amd64.exe

if not exist "%INSTALLER%" (
    echo ERROR: Installer not found at %INSTALLER%
    echo Run 1_download.bat first.
    pause
    exit /b 1
)

echo Running installer: %INSTALLER%
"%INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

echo.
echo Waiting for installation to finish...
timeout /t 10 /nobreak >nul

REM Refresh PATH in this session so python is usable immediately
for /f "skip=2 tokens=3*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path') do set "SysPath=%%A %%B"
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "UserPath=%%A %%B"
set "PATH=%SysPath%;%UserPath%"

echo.
echo Verifying installation...
python --version
if errorlevel 1 (
    echo WARNING: Python not detected on PATH yet.
    echo You may need to close and reopen cmd before running 3_packages.bat.
) else (
    echo Python installed successfully.
)

pause
exit /b 0