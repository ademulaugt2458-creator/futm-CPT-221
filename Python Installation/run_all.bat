@echo off
echo ============================================
echo  Full Setup: Python 3.14.7 + Packages
echo ============================================

set SCRIPT_DIR=%~dp0

echo.
echo Running 1_download.bat...
call "%SCRIPT_DIR%download_python.bat"
if errorlevel 1 (
    echo Download step failed. Aborting.
    pause
    exit /b 1
)

echo.
echo Running 2_install_python.bat...
call "%SCRIPT_DIR%install_python.bat"
if errorlevel 1 (
    echo Install step failed. Aborting.
    pause
    exit /b 1
)

echo.
echo Running 3_install_requirements.bat...
call "%SCRIPT_DIR%install_requirement.bat"
if errorlevel 1 (
    echo Package install step failed. Aborting.
    pause
    exit /b 1
)

echo.
echo ============================================
echo  All steps completed successfully.
echo ============================================
pause
exit /b 0