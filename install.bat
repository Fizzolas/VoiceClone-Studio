@echo off
REM VoiceClone Studio - Windows Installation Script
REM This script installs all dependencies and sets up the application

echo ========================================
echo VoiceClone Studio - Installation
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.10 or higher from python.org
    pause
    exit /b 1
)

echo Checking Python version...
python -c "import sys; exit(0 if sys.version_info >= (3, 10) else 1)"
if errorlevel 1 (
    echo ERROR: Python 3.10 or higher is required
    echo Current version:
    python --version
    pause
    exit /b 1
)

echo Python version OK
echo.

REM Create virtual environment
echo Creating virtual environment...
if exist venv (
    echo Virtual environment already exists
) else (
    python -m venv venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment
        pause
        exit /b 1
    )
    echo Virtual environment created
)
echo.

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERROR: Failed to activate virtual environment
    pause
    exit /b 1
)
echo.

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip
echo.

REM Install PyTorch (CUDA version if available)
echo Detecting GPU...
python -c "import subprocess; subprocess.run(['nvidia-smi'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL); exit(0)" >nul 2>&1
if errorlevel 1 (
    echo No NVIDIA GPU detected, installing CPU version of PyTorch
    pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
) else (
    echo NVIDIA GPU detected, installing CUDA version of PyTorch
    pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu118
)
echo.

REM Install other dependencies
echo Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)
echo.

REM Create necessary directories
echo Creating directory structure...
if not exist "data\recordings" mkdir "data\recordings"
if not exist "data\uploads" mkdir "data\uploads"
if not exist "data\cache" mkdir "data\cache"
if not exist "models\base" mkdir "models\base"
if not exist "models\user" mkdir "models\user"
if not exist "logs" mkdir "logs"
echo.

REM Copy configuration template
echo Setting up configuration...
if not exist "config.yaml" (
    copy config.template.yaml config.yaml
    echo Created config.yaml from template
) else (
    echo config.yaml already exists
)
echo.

REM Download base models
echo Downloading base models...
python scripts/download_models.py
echo.

REM Create desktop shortcut (optional)
echo Creating desktop shortcut...
python scripts/create_shortcut.py
echo.

echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo To run VoiceClone Studio:
echo   1. Double-click the desktop shortcut, OR
echo   2. Run: venv\Scripts\activate.bat
echo           python main.py
echo.
echo For API mode: python main.py --mode api
echo For CLI mode: python main.py --mode cli --help
echo.
pause