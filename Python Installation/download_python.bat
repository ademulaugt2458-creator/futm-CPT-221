@echo off
echo ============================================
echo  Step 1: Downloading Python 3.14.7
echo ============================================

set URL=https://www.python.org/ftp/python/3.14.7/python-3.14.7-amd64.exe
set DEST=%USERPROFILE%\Downloads\python-3.14.7-amd64.exe

echo Downloading to: %DEST%
curl -L -o "%DEST%" %URL%

if not exist "%DEST%" (
    echo ERROR: Download failed. Check your internet connection.
    pause
    exit /b 1
)

echo.
echo Download complete: %DEST%
pause
exit /b 0