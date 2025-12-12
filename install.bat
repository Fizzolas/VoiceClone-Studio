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

REM Install pipwin for easier PyAudio installation
echo Installing pipwin for PyAudio...
pip install pipwin
echo.

REM Try to install PyAudio via pipwin
echo Installing PyAudio...
pipwin install pyaudio
if errorlevel 1 (
    echo.
    echo PyAudio installation via pipwin failed.
    echo Will use sounddevice as alternative (already in requirements.txt)
    echo.
    echo If you want PyAudio specifically, download the wheel file from:
    echo https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio
    echo Then install with: pip install downloaded_file.whl
    echo.
)
echo.

REM Install other dependencies
echo Installing remaining dependencies...
pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    echo.
    echo Common issues:
    echo - If Coqui TTS fails: Try pip install coqui-tts --no-deps then pip install -r requirements.txt
    echo - If phonemizer fails: Make sure espeak-ng is installed and in PATH
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
if not exist "scripts" mkdir "scripts"
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
echo 2. To run VoiceClone Studio:
echo    - Double-click the desktop shortcut, OR
echo    - Run: venv\Scripts\activate.bat
echo            python main.py
echo.
echo 3. For API mode: python main.py --mode api
echo 4. For CLI mode: python main.py --mode cli --help
echo.
echo 5. If you encounter "espeak-ng not found" errors:
echo    - Add C:\Program Files\eSpeak NG\ to your PATH
echo    - OR set PHONEMIZER_ESPEAK_LIBRARY environment variable
echo.
pause