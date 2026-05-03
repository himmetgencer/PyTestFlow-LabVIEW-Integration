@echo off
echo ==============================================
echo Starting PyTestFlow UI
echo ==============================================

if not exist ".venv\Scripts\activate.bat" (
    echo Error: Virtual environment not found!
    echo Please run install.bat first.
    pause
    exit /b 1
)

call .venv\Scripts\activate.bat
set PYTESTFLOW_HOME=%CD%
pytestflow start --open
pause
