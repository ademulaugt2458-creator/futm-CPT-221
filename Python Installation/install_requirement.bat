@echo off
echo ============================================
echo  Step 3: Installing Python Packages
echo ============================================

python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found on PATH. Run 2_install.bat first,
    echo then close/reopen this terminal.
    pause
    exit /b 1
)

echo Upgrading pip...
python -m pip install --upgrade pip

echo.
echo Installing numpy and scipy...
python -m pip install numpy scipy

echo.
echo Checking "fractions" support (this is a built-in module, not a pip package)...
python -c "from fractions import Fraction; print('fractions module OK:', Fraction(1,3))"

echo.
echo ============================================
echo  Verification
echo ============================================
python -m pip show numpy | findstr "Name Version"
python -m pip show scipy | findstr "Name Version"

echo.
echo Package setup complete.
pause
exit /b 0