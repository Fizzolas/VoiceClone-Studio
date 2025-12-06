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
    echo Please install Python 3.10, 3.11, or 3.12 from python.org
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Checking Python version...
for /f "tokens=2" %%I in ('python --version') do set PYTHON_VERSION=%%I
echo Found Python %PYTHON_VERSION%

python -c "import sys; exit(0 if (3, 10) <= sys.version_info[:2] <= (3, 12) else 1)"
if errorlevel 1 (
    echo ERROR: Python 3.10, 3.11, or 3.12 is required
    echo Python 3.13+ is not yet fully supported by all dependencies
    echo Current version: %PYTHON_VERSION%
    echo.
    echo Please install Python 3.10, 3.11, or 3.12 from:
    echo https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Python version OK: %PYTHON_VERSION%
echo.

REM Create virtual environment
echo Creating virtual environment...
if exist venv (
    echo Virtual environment already exists
    echo Deleting old virtual environment...
    rmdir /s /q venv
)

python -m venv venv
if errorlevel 1 (
    echo ERROR: Failed to create virtual environment
    pause
    exit /b 1
)
echo Virtual environment created
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
echo Upgrading pip, setuptools, and wheel...
python -m pip install --upgrade pip setuptools wheel
echo.

REM Detect GPU and install PyTorch
echo ========================================
echo Detecting GPU for PyTorch installation...
echo ========================================
echo.

nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo No NVIDIA GPU detected
    echo Installing CPU-only version of PyTorch...
    echo.
    pip install torch torchaudio
) else (
    echo NVIDIA GPU detected!
    echo.
    echo Select PyTorch CUDA version:
    echo   1. CUDA 12.4 (Recommended for RTX 40-series and newer)
    echo   2. CUDA 12.1 (For older RTX 30-series GPUs)
    echo   3. CPU only (No GPU acceleration)
    echo.
    set /p CUDA_CHOICE="Enter choice (1-3) [default: 1]: "
    
    if "%CUDA_CHOICE%"=="" set CUDA_CHOICE=1
    if "%CUDA_CHOICE%"=="3" (
        echo Installing CPU-only PyTorch...
        pip install torch torchaudio
    ) else if "%CUDA_CHOICE%"=="2" (
        echo Installing PyTorch with CUDA 12.1...
        pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu121
    ) else (
        echo Installing PyTorch with CUDA 12.4 (default)...
        pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu124
    )
)

if errorlevel 1 (
    echo ERROR: Failed to install PyTorch
    echo Please check your internet connection and try again
    pause
    exit /b 1
)
echo.

REM Install other dependencies
echo ========================================
echo Installing remaining dependencies...
echo This may take several minutes...
echo ========================================
echo.

pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo WARNING: Some packages failed to install
    echo Common issues:
    echo   - PyAudio requires Microsoft Visual C++ Build Tools
    echo   - phonemizer requires espeak-ng (download from: https://github.com/espeak-ng/espeak-ng/releases)
    echo.
    echo The application may still work with sounddevice instead of PyAudio
    echo.
    pause
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
echo Directory structure created
echo.

REM Copy configuration template
echo Setting up configuration...
if not exist "config.yaml" (
    copy config.template.yaml config.yaml
    echo Created config.yaml from template
) else (
    echo config.yaml already exists - skipping
)
echo.

REM Create placeholder for download_models.py if it doesn't exist
if not exist "scripts\download_models.py" (
    echo Creating placeholder download_models.py script...
    (
        echo # Model Download Script
        echo # This script will download pre-trained base models
        echo print^("Model download not yet implemented"^)
        echo print^("Models will be downloaded automatically on first run"^)
    ) > scripts\download_models.py
)

REM Download base models (if script exists)
echo.
echo Note: Base models will be downloaded automatically on first use
echo to save installation time and bandwidth.
echo.

REM Verify installation
echo ========================================
echo Verifying installation...
echo ========================================
echo.

python -c "import torch; print('PyTorch:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"
python -c "import PyQt6; print('PyQt6: OK')"
python -c "import sounddevice; print('sounddevice: OK')"

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo To run VoiceClone Studio:
echo   1. Activate virtual environment:
 echo      venv\Scripts\activate.bat
echo   2. Run the application:
echo      python main.py
echo.
echo For API mode: python main.py --mode api
echo For CLI help: python main.py --mode cli --help
echo.
echo IMPORTANT NOTES:
echo - If you encounter audio issues, install espeak-ng from:
echo   https://github.com/espeak-ng/espeak-ng/releases
echo - For PyAudio support, install Microsoft Visual C++ Build Tools
echo.
pause