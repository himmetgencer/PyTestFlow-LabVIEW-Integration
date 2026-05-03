@echo off
echo ==============================================
echo PyTestFlow 1-Click Installer
echo ==============================================

if not exist "PyTestFlow" (
    echo.
    echo [1/5] Cloning PyTestFlow repository...
    git clone https://github.com/Alberto-Manzoni/PyTestFlow.git
) else (
    echo.
    echo [1/5] PyTestFlow repository already exists.
)

echo.
echo [2/5] Applying Python 3.10 compatibility fixes...
echo import sys> fix_syntax.py
echo with open('PyTestFlow/setup.py', 'r', encoding='utf-8') as f: d = f.read()>> fix_syntax.py
echo d = d.replace('python_requires=">=3.11"', 'python_requires=">=3.10"')>> fix_syntax.py
echo with open('PyTestFlow/setup.py', 'w', encoding='utf-8') as f: f.write(d)>> fix_syntax.py
echo with open('PyTestFlow/pytestflow/backend/start_backend.py', 'r', encoding='utf-8') as f: d = f.read()>> fix_syntax.py
echo old1 = 'f"http://{CONFIG[\"http\"][\"host\"]}:{CONFIG[\"http\"][\"port\"]}/"'>> fix_syntax.py
echo new1 = "f'http://{CONFIG[\"http\"][\"host\"]}:{CONFIG[\"http\"][\"port\"]}/'">> fix_syntax.py
echo d = d.replace(old1, new1)>> fix_syntax.py
echo old2 = 'f"ws://{CONFIG[\"websocket\"][\"host\"]}:{CONFIG[\"websocket\"][\"port\"]}"'>> fix_syntax.py
echo new2 = "f'ws://{CONFIG[\"websocket\"][\"host\"]}:{CONFIG[\"websocket\"][\"port\"]}'">> fix_syntax.py
echo d = d.replace(old2, new2)>> fix_syntax.py
echo with open('PyTestFlow/pytestflow/backend/start_backend.py', 'w', encoding='utf-8') as f: f.write(d)>> fix_syntax.py
python fix_syntax.py
del fix_syntax.py

echo.
echo [3/5] Creating virtual environment (.venv)...
if not exist ".venv" (
    python -m venv .venv
    if errorlevel 1 (
        echo Failed to create virtual environment!
        pause
        exit /b 1
    )
) else (
    echo Virtual environment already exists.
)

echo.
echo [4/5] Installing PyTestFlow and JKI Python Bridge...
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip setuptools wheel
python -m pip install -e .\PyTestFlow
if errorlevel 1 (
    echo Failed to install PyTestFlow!
    pause
    exit /b 1
)

python -m pip install jki-python-bridge-for-labview
if errorlevel 1 (
    echo Failed to install JKI Python Bridge!
    pause
    exit /b 1
)

echo.
echo [5/5] Initializing workspace...
echo c | pytestflow init

echo.
echo ==============================================
echo Installation Complete!
echo You can now use run_pytestflow.bat to start it.
echo ==============================================
pause
