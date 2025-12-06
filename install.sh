#!/bin/bash
# VoiceClone Studio - Linux/macOS Installation Script
# This script installs all dependencies and sets up the application

set -e  # Exit on error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "VoiceClone Studio - Installation"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}ERROR: Python 3 is not installed${NC}"
    echo "Please install Python 3.10, 3.11, or 3.12"
    exit 1
fi

echo "Checking Python version..."
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
echo -e "Found Python ${GREEN}$PYTHON_VERSION${NC}"

# Check Python version is between 3.10 and 3.12
python3 -c 'import sys; exit(0 if (3, 10) <= sys.version_info[:2] <= (3, 12) else 1)'
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Python 3.10, 3.11, or 3.12 is required${NC}"
    echo "Python 3.13+ is not yet fully supported by all dependencies"
    echo "Current version: $PYTHON_VERSION"
    exit 1
fi

echo -e "${GREEN}Python version OK: $PYTHON_VERSION${NC}"
echo ""

# Create virtual environment
echo "Creating virtual environment..."
if [ -d "venv" ]; then
    echo -e "${YELLOW}Virtual environment already exists - removing old version${NC}"
    rm -rf venv
fi

python3 -m venv venv
echo -e "${GREEN}Virtual environment created${NC}"
echo ""

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo ""

# Upgrade pip
echo "Upgrading pip, setuptools, and wheel..."
pip install --upgrade pip setuptools wheel
echo ""

# Detect OS and install system dependencies
echo "========================================"
echo "Checking system dependencies..."
echo "========================================"
echo ""

OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
    echo -e "${GREEN}macOS detected${NC}"
    
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}WARNING: Homebrew not found${NC}"
        echo "Install Homebrew from: https://brew.sh"
        echo "Then run: brew install portaudio espeak-ng"
    else
        echo "Installing system dependencies via Homebrew..."
        brew install portaudio espeak-ng || echo -e "${YELLOW}Some packages may already be installed${NC}"
    fi
    
    # Install PyTorch for macOS
    echo ""
    echo "Installing PyTorch for macOS..."
    if [ "$(uname -m)" = "arm64" ]; then
        echo -e "${GREEN}Apple Silicon detected - installing optimized PyTorch${NC}"
    else
        echo "Intel Mac detected"
    fi
    pip install torch torchaudio
    
elif [ "$OS" = "Linux" ]; then
    echo -e "${GREEN}Linux detected${NC}"
    
    # Detect package manager and suggest system packages
    if command -v apt-get &> /dev/null; then
        echo "Debian/Ubuntu detected"
        echo -e "${YELLOW}You may need to install system packages:${NC}"
        echo "  sudo apt-get update"
        echo "  sudo apt-get install -y portaudio19-dev espeak-ng python3-dev build-essential"
        echo ""
        read -p "Install system packages now? (requires sudo) [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt-get update
            sudo apt-get install -y portaudio19-dev espeak-ng python3-dev build-essential
        fi
    elif command -v dnf &> /dev/null; then
        echo "Fedora/RHEL detected"
        echo -e "${YELLOW}You may need to install system packages:${NC}"
        echo "  sudo dnf install portaudio-devel espeak-ng python3-devel gcc gcc-c++"
    elif command -v pacman &> /dev/null; then
        echo "Arch Linux detected"
        echo -e "${YELLOW}You may need to install system packages:${NC}"
        echo "  sudo pacman -S portaudio espeak-ng base-devel"
    fi
    
    echo ""
    # Detect GPU and install PyTorch
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${GREEN}NVIDIA GPU detected!${NC}"
        nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1
        echo ""
        echo "Select PyTorch CUDA version:"
        echo "  1. CUDA 12.4 (Recommended for RTX 40-series and newer)"
        echo "  2. CUDA 12.1 (For older RTX 30-series GPUs)"
        echo "  3. CPU only (No GPU acceleration)"
        echo ""
        read -p "Enter choice (1-3) [default: 1]: " CUDA_CHOICE
        
        CUDA_CHOICE=${CUDA_CHOICE:-1}
        
        case $CUDA_CHOICE in
            3)
                echo "Installing CPU-only PyTorch..."
                pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
                ;;
            2)
                echo "Installing PyTorch with CUDA 12.1..."
                pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu121
                ;;
            *)
                echo "Installing PyTorch with CUDA 12.4 (default)..."
                pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu124
                ;;
        esac
    else
        echo "No NVIDIA GPU detected"
        echo "Installing CPU-only version of PyTorch..."
        pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
    fi
fi

echo ""

# Install other dependencies
echo "========================================"
echo "Installing Python dependencies..."
echo "This may take several minutes..."
echo "========================================"
echo ""

pip install -r requirements.txt || {
    echo ""
    echo -e "${YELLOW}WARNING: Some packages failed to install${NC}"
    echo "Common issues:"
    echo "  - phonemizer requires espeak-ng system package"
    echo "  - PyAudio requires portaudio development headers"
    echo ""
    echo "The application may still work with sounddevice instead of PyAudio"
    echo ""
}

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
echo -e "${GREEN}Directory structure created${NC}"
echo ""

# Copy configuration template
echo "Setting up configuration..."
if [ ! -f "config.yaml" ]; then
    cp config.template.yaml config.yaml
    echo -e "${GREEN}Created config.yaml from template${NC}"
else
    echo "config.yaml already exists - skipping"
fi
echo ""

# Create placeholder for download_models.py if it doesn't exist
if [ ! -f "scripts/download_models.py" ]; then
    echo "Creating placeholder download_models.py script..."
    cat > scripts/download_models.py << 'EOF'
# Model Download Script
# This script will download pre-trained base models
print("Model download not yet implemented")
print("Models will be downloaded automatically on first run")
EOF
    chmod +x scripts/download_models.py
fi

# Make scripts executable
echo "Setting permissions..."
chmod +x main.py
chmod +x scripts/*.py 2>/dev/null || true
echo ""

echo "Note: Base models will be downloaded automatically on first use"
echo "to save installation time and bandwidth."
echo ""

# Verify installation
echo "========================================"
echo "Verifying installation..."
echo "========================================"
echo ""

python -c "import torch; print('PyTorch:', torch.__version__); print('CUDA available:', torch.cuda.is_available())" || echo -e "${YELLOW}PyTorch check failed${NC}"
python -c "import PyQt6; print('PyQt6: OK')" || echo -e "${YELLOW}PyQt6 check failed${NC}"
python -c "import sounddevice; print('sounddevice: OK')" || echo -e "${YELLOW}sounddevice check failed${NC}"

echo ""
echo "========================================"
echo -e "${GREEN}Installation Complete!${NC}"
echo "========================================"
echo ""
echo "To run VoiceClone Studio:"
echo "  1. Activate the virtual environment:"
echo -e "     ${GREEN}source venv/bin/activate${NC}"
echo "  2. Run the application:"
echo -e "     ${GREEN}python main.py${NC}"
echo ""
echo "For API mode: python main.py --mode api"
echo "For CLI help: python main.py --mode cli --help"
echo ""
echo -e "${YELLOW}IMPORTANT NOTES:${NC}"
echo "- If you encounter audio issues, ensure espeak-ng is installed"
echo "- For GPU support, verify CUDA drivers are properly installed"
echo ""