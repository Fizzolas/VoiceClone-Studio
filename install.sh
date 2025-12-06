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

# Detect OS and install PyTorch accordingly
echo "Detecting system..."
OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
    echo "macOS detected"
    # Check for Apple Silicon
    if [ "$(uname -m)" = "arm64" ]; then
        echo "Apple Silicon detected, installing optimized PyTorch"
    else
        echo "Intel Mac detected"
    fi
    pip install torch torchaudio
else
    echo "Linux detected"
    # Check for NVIDIA GPU
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA GPU detected, installing CUDA version of PyTorch"
        pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu118
    else
        echo "No NVIDIA GPU detected, installing CPU version of PyTorch"
        pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
    fi
fi
echo ""

# Install other dependencies
echo "Installing dependencies..."
pip install -r requirements.txt
echo ""

# Install system dependencies (Linux only)
if [ "$OS" = "Linux" ]; then
    echo "Checking for system dependencies..."
    if command -v apt-get &> /dev/null; then
        echo "Debian/Ubuntu detected"
        echo "You may need to install: sudo apt-get install portaudio19-dev python3-pyaudio"
    elif command -v yum &> /dev/null; then
        echo "RedHat/CentOS detected"
        echo "You may need to install: sudo yum install portaudio-devel"
    fi
    echo ""
fi

# Create necessary directories
echo "Creating directory structure..."
mkdir -p data/recordings
mkdir -p data/uploads
mkdir -p data/cache
mkdir -p models/base
mkdir -p models/user
mkdir -p logs
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

# Download base models
echo "Downloading base models..."
python scripts/download_models.py
echo ""

# Make scripts executable
echo "Setting permissions..."
chmod +x main.py
chmod +x scripts/*.py
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