@echo off
setlocal enabledelayedexpansion

echo ============================================
echo  Installing packages from requirements.txt
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

    REM Skip blank lines and comment lines starting with #
    if not "!PKG!"=="" (
        if not "!PKG:~0,1!"=="#" (

            REM Strip any version specifier, e.g. numpy==2.1.0 -> numpy
            for /f "delims=<>=! " %%P in ("!PKG!") do set "PKGNAME=%%P"

            python -m pip show !PKGNAME! >nul 2>&1
            if not errorlevel 1 (
                echo "!PKGNAME! has already been installed"
            ) else (
                echo "installing !PKGNAME!"
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

echo.
echo ============================================
echo  Done.
echo ============================================
pause
exit /b 0