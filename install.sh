#!/bin/bash
# VoiceClone Studio - Linux/macOS Installation Script
# This script installs all dependencies and sets up the application

set -e  # Exit on error

echo "========================================"
echo "VoiceClone Studio - Installation"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    echo "Please install Python 3.10 or higher"
    exit 1
fi

echo "Checking Python version..."
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
REQUIRED_VERSION="3.10"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "ERROR: Python 3.10 or higher is required"
    echo "Current version: $PYTHON_VERSION"
    exit 1
fi

echo "Python version OK: $PYTHON_VERSION"
echo ""

# Detect OS
OS="$(uname -s)"
echo "Detected OS: $OS"
echo ""

# Install system dependencies
echo "========================================"
echo "Installing System Dependencies"
echo "========================================"
echo ""

if [ "$OS" = "Darwin" ]; then
    echo "macOS detected"
    echo "Checking for Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Please install it from https://brew.sh"
        exit 1
    fi
    
    echo "Installing espeak-ng and portaudio..."
    brew install espeak-ng portaudio
    
else
    echo "Linux detected"
    
    if command -v apt-get &> /dev/null; then
        echo "Debian/Ubuntu detected"
        echo "Installing required packages..."
        echo "This may require sudo password:"
        sudo apt-get update
        sudo apt-get install -y espeak-ng portaudio19-dev python3-pyaudio ffmpeg
        
    elif command -v yum &> /dev/null; then
        echo "RedHat/CentOS/Fedora detected"
        echo "Installing required packages..."
        echo "This may require sudo password:"
        sudo yum install -y espeak-ng portaudio-devel python3-pyaudio ffmpeg
        
    elif command -v pacman &> /dev/null; then
        echo "Arch Linux detected"
        echo "Installing required packages..."
        echo "This may require sudo password:"
        sudo pacman -S --noconfirm espeak-ng portaudio python-pyaudio ffmpeg
        
    else
        echo "WARNING: Unknown package manager. Please manually install:"
        echo "  - espeak-ng"
        echo "  - portaudio development files"
        echo "  - ffmpeg"
        echo ""
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi

echo ""

# Create virtual environment
echo "Creating virtual environment..."
if [ -d "venv" ]; then
    echo "Virtual environment already exists"
else
    python3 -m venv venv
    echo "Virtual environment created"
fi
echo ""

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo ""

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip
echo ""

# Install PyTorch based on platform
echo "Installing PyTorch..."

if [ "$OS" = "Darwin" ]; then
    echo "macOS detected"
    # Check for Apple Silicon
    if [ "$(uname -m)" = "arm64" ]; then
        echo "Apple Silicon detected, installing optimized PyTorch with Metal support"
    else
        echo "Intel Mac detected"
    fi
    pip install torch torchaudio
    
else
    echo "Linux detected"
    # Check for NVIDIA GPU
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA GPU detected"
        
        # Check driver version
        DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n1)
        echo "NVIDIA Driver Version: $DRIVER_VERSION"
        
        # CUDA 12.6 requires driver >= 525.60.13
        echo "Installing PyTorch with CUDA 12.6 support"
        echo "Note: Requires NVIDIA driver 525.60.13 or newer"
        pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu126
        
    else
        echo "No NVIDIA GPU detected, installing CPU version of PyTorch"
        pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
    fi
fi
echo ""

# Install other dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Failed to install dependencies"
    echo ""
    echo "Common issues:"
    echo "  - If Coqui TTS fails: Make sure espeak-ng is installed"
    echo "  - If phonemizer fails: Check that espeak-ng is in your PATH"
    echo "  - If PyAudio fails: Install portaudio development files"
    echo ""
    exit 1
fi
echo ""

# Create necessary directories
echo "Creating directory structure..."
mkdir -p data/recordings
mkdir -p data/uploads
mkdir -p data/cache
mkdir -p models/base
mkdir -p models/user
mkdir -p logs
mkdir -p src
mkdir -p scripts
echo ""

# Copy configuration template
echo "Setting up configuration..."
if [ ! -f "config.yaml" ]; then
    cp config.template.yaml config.yaml
    echo "Created config.yaml from template"
else
    echo "config.yaml already exists"
fi
echo ""

# Create placeholder scripts if they don't exist
if [ ! -f "scripts/download_models.py" ]; then
    echo "Creating placeholder download_models.py..."
    cat > scripts/download_models.py << 'EOF'
# Placeholder for model download script
print("Model download functionality coming soon!")
print("Models will be downloaded on first use.")
EOF
fi

if [ ! -f "scripts/create_shortcut.py" ]; then
    echo "Creating placeholder create_shortcut.py..."
    cat > scripts/create_shortcut.py << 'EOF'
# Placeholder for shortcut creation
print("Desktop shortcut creation - optional feature")
EOF
fi

# Download base models
echo "Downloading base models..."
python scripts/download_models.py
echo ""

# Make scripts executable
echo "Setting permissions..."
chmod +x main.py
chmod +x scripts/*.py
chmod +x install.sh
echo ""

echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo ""
echo "To run VoiceClone Studio:"
echo "  1. Activate the virtual environment:"
echo "     source venv/bin/activate"
echo "  2. Run the application:"
echo "     python main.py"
echo ""
echo "For API mode: python main.py --mode api"
echo "For CLI mode: python main.py --mode cli --help"
echo ""
echo "NOTES:"
echo "  - espeak-ng has been installed for voice synthesis"
echo "  - If you encounter audio issues, check that your audio device is configured"
echo "  - For GPU acceleration, make sure your drivers are up to date"
echo ""