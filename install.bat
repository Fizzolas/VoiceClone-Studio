@echo off
REM VoiceClone-Studio - Windows Installation Script
REM This script installs all dependencies and sets up the application

echo ========================================
echo VoiceClone Studio - Installation
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.10, 3.11, or 3.12 from python.org
    pause
    exit /b 1
)

echo Checking Python version...

REM Get Python version and check compatibility
python -c "import sys; v = sys.version_info; exit(0 if (v.major == 3 and 10 <= v.minor <= 12) else 1)"
if errorlevel 1 (
    echo.
    echo ================================================
    echo ERROR: Incompatible Python Version
    echo ================================================
    echo.
    echo Current Python version:
    python --version
    echo.
    echo REQUIRED: Python 3.10, 3.11, or 3.12
    echo NOT SUPPORTED: Python 3.13, 3.14, or 3.9 and below
    echo.
    echo Why? The coqui-tts library does not support Python 3.13+
    echo.
    echo SOLUTIONS:
    echo   1. Install Python 3.11 (recommended):
    echo      winget install -e --id Python.Python.3.11 --scope machine
    echo.
    echo   2. Install Python 3.12:
    echo      winget install -e --id Python.Python.3.12 --scope machine
    echo.
    echo   3. After installing, create a new venv with specific version:
    echo      py -3.11 -m venv venv
    echo.
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
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo No NVIDIA GPU detected, installing CPU version of PyTorch
    pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
) else (
    echo NVIDIA GPU detected, installing CUDA 12.6 version of PyTorch
    echo Note: This requires NVIDIA driver 525.60.13 or newer
    pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu126
)
echo.

REM Install espeak-ng (required for phonemizer)
echo.
echo ========================================
echo IMPORTANT: espeak-ng Installation
echo ========================================
echo.
echo espeak-ng is required for voice cloning to work.
echo.
echo Please download and install espeak-ng from:
echo https://github.com/espeak-ng/espeak-ng/releases
echo.
echo Download: espeak-ng-X64.msi (for 64-bit Windows)
echo.
echo After installation, you may need to add it to your PATH:
echo C:\Program Files\eSpeak NG\
echo.
set /p "ESPEAK_INSTALLED=Have you installed espeak-ng? (y/n): "
if /i "%ESPEAK_INSTALLED%" neq "y" (
    echo.
    echo WARNING: Continuing without espeak-ng may cause errors.
    echo You can install it later and re-run this script.
    echo.
)
echo.

REM Skip pipwin entirely - it's broken on Python 3.14 and unreliable
echo NOTE: Skipping PyAudio installation (use sounddevice instead)
echo PyAudio is optional. If you need it, download from:
echo https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio
echo Then install with: pip install downloaded_file.whl
echo.

REM Install other dependencies
echo Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo ========================================
    echo ERROR: Failed to install dependencies
    echo ========================================
    echo.
    echo Common issues:
    echo   1. Python 3.13/3.14: Not supported by coqui-tts
    echo      Solution: Use Python 3.10, 3.11, or 3.12
    echo.
    echo   2. espeak-ng not found: phonemizer will fail
    echo      Solution: Install espeak-ng and add to PATH
    echo.
    echo   3. Network issues: Unable to download packages
    echo      Solution: Check internet connection
    echo.
    echo For more help, see TROUBLESHOOTING.md
    echo.
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
if not exist "src" mkdir "src"
if not exist "src\gui" mkdir "src\gui"
if not exist "src\models" mkdir "src\models"
if not exist "src\audio" mkdir "src\audio"
if not exist "src\api" mkdir "src\api"
if not exist "src\utils" mkdir "src\utils"
if not exist "scripts" mkdir "scripts"
echo.

REM Create __init__.py files for Python modules
echo Creating Python module structure...
type nul > src\__init__.py
type nul > src\gui\__init__.py
type nul > src\models\__init__.py
type nul > src\audio\__init__.py
type nul > src\api\__init__.py
type nul > src\utils\__init__.py
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

REM Create placeholder scripts if they don't exist
if not exist "scripts\download_models.py" (
    echo Creating placeholder download_models.py...
    (
        echo # Placeholder for model download script
        echo print("Model download functionality coming soon!"^)
        echo print("Models will be downloaded on first use."^)
    ) > scripts\download_models.py
)

if not exist "scripts\create_shortcut.py" (
    echo Creating placeholder create_shortcut.py...
    (
        echo # Placeholder for shortcut creation
        echo print("Desktop shortcut creation - optional feature"^)
    ) > scripts\create_shortcut.py
)

echo.
echo Downloading base models...
python scripts\download_models.py
echo.

echo Creating desktop shortcut...
python scripts\create_shortcut.py
echo.

echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo IMPORTANT NOTES:
echo 1. Make sure espeak-ng is installed from:
echo    https://github.com/espeak-ng/espeak-ng/releases
echo.
echo 2. Your Python version:
python --version
echo    (Must be 3.10, 3.11, or 3.12)
echo.
echo 3. To run VoiceClone Studio:
echo    venv\Scripts\activate.bat
echo    python main.py
echo.
echo 4. For API mode: python main.py --mode api
echo 5. For CLI mode: python main.py --mode cli --help
echo.
echo 6. If you encounter "espeak-ng not found" errors:
echo    - Add C:\Program Files\eSpeak NG\ to your PATH
echo    - OR set PHONEMIZER_ESPEAK_LIBRARY environment variable
echo.
echo NOTE: The GUI is not yet implemented (coming in v0.2.0)
echo       The application will show an error - this is expected.
echo.
pause