# Installation Notes - Compatibility & Requirements

## Tested Configurations

As of December 2025, VoiceClone Studio has been tested with:

### Operating Systems
- **Windows:** 10, 11 (64-bit)
- **Linux:** Ubuntu 20.04+, Debian 11+, Fedora 35+, Arch Linux (current)
- **macOS:** 12 (Monterey) and newer, including Apple Silicon (M1/M2/M3)

### Python Versions
- **Recommended:** Python 3.10 or 3.11
- **Supported:** Python 3.10, 3.11, 3.12
- **Not Supported:** Python 3.9 (too old), Python 3.13 (too new - dependencies not ready)

**Why Python 3.13 is not supported:**
- Some dependencies (like certain C extensions) haven't been updated yet
- The `coqui-tts` fork supports up to Python 3.12
- Wait for ecosystem maturity before using Python 3.13

### GPU Support

#### NVIDIA GPUs
- **CUDA 12.6** (recommended for new installations)
  - Requires NVIDIA driver >= 525.60.13
  - Best performance with RTX 30/40 series
  - Installation: `pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu126`

- **CUDA 11.8** (for older drivers)
  - Requires NVIDIA driver >= 450.80.02
  - Compatible with older GPUs (GTX 10 series and up)
  - Installation: `pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu118`

**Note:** PyTorch bundles all required CUDA libraries - you don't need to install CUDA toolkit separately.

#### AMD GPUs
- ROCm 6.0 support available on Linux
- Installation: `pip install torch torchaudio --index-url https://download.pytorch.org/whl/rocm6.0`
- **Windows:** AMD GPU acceleration not supported (use CPU mode)

#### Apple Silicon (M1/M2/M3)
- Metal acceleration included in standard PyTorch
- Excellent performance for inference
- Training performance is good but slower than NVIDIA GPUs

## Critical Dependencies

### 1. Coqui TTS

**Package:** `coqui-tts` (NOT the original `TTS` package)

**Why the change:**
- Original Coqui AI company shut down in 2023
- Original `TTS` package only supports Python < 3.12
- Idiap Research Institute maintains a fork with Python 3.12+ support

**Installation:**
```bash
pip install coqui-tts>=0.24.0
```

**Version Notes:**
- v0.24.2+: Includes precompiled wheels for Windows, macOS, and Linux
- v0.25.0: Added OpenVoice models for voice conversion
- Latest supports XTTSv2 with 17 languages

### 2. espeak-ng (System Dependency)

**Required for:** `phonemizer` package (text-to-phoneme conversion)

**This MUST be installed separately** - it's not a Python package!

**Installation by Platform:**

**Windows:**
1. Download: [espeak-ng releases](https://github.com/espeak-ng/espeak-ng/releases)
2. Install `espeak-ng-X64.msi`
3. Add to PATH or set environment variable:
   ```cmd
   setx PHONEMIZER_ESPEAK_LIBRARY "C:\Program Files\eSpeak NG\libespeak-ng.dll"
   ```

**Linux:**
```bash
# Debian/Ubuntu
sudo apt-get install espeak-ng

# Fedora/RHEL
sudo dnf install espeak-ng

# Arch
sudo pacman -S espeak-ng
```

**macOS:**
```bash
brew install espeak-ng
```

### 3. PyAudio vs sounddevice

**PyAudio Issues:**
- Difficult to install on Windows (requires Visual C++ build tools)
- Installation varies widely by platform
- Hasn't been updated since 2017

**Our Solution:**
We use `sounddevice` as the default audio library:
- Easier cross-platform installation
- More actively maintained
- Better performance
- Pure Python wheels available

**If you specifically need PyAudio:**

**Windows:**
```bash
pip install pipwin
pipwin install pyaudio
```

**Linux:**
```bash
sudo apt-get install portaudio19-dev  # Debian/Ubuntu
pip install pyaudio
```

**macOS:**
```bash
brew install portaudio
pip install pyaudio
```

### 4. PyQt6

**Current Version:** 6.10.0 (as of October 2025)

**Compatibility:**
- Works with Python 3.10, 3.11, 3.12
- Requires Qt 6.10
- All platforms supported

**Installation:**
```bash
pip install PyQt6>=6.5.0  # Minimum version
```

### 5. PyTorch

**Current Stable:** 2.7.0 (supports CUDA 11.8, 12.6, 12.8)

**Compatibility Matrix:**
```
PyTorch 2.7:
- Python: 3.9 - 3.13 (3.13 experimental)
- CUDA: 11.8, 12.6, 12.8
- C++ Standard: C++17
```

**Important:** Always install PyTorch **before** other dependencies to ensure version compatibility.

## Common Installation Workflows

### Fresh Installation (Recommended)

```bash
# 1. Create virtual environment
python3.11 -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# 2. Upgrade pip
pip install --upgrade pip

# 3. Install PyTorch (choose one):
# For CUDA 12.6:
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu126
# For CUDA 11.8:
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu118
# For CPU only:
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu

# 4. Install other dependencies
pip install -r requirements.txt

# 5. Install system dependencies (espeak-ng)
# See platform-specific instructions above
```

### Upgrading Existing Installation

```bash
# Activate virtual environment
source venv/bin/activate

# Update all packages
pip install --upgrade -r requirements.txt

# If PyTorch needs updating:
pip install --upgrade torch torchaudio --index-url https://download.pytorch.org/whl/cu126
```

### Minimal Installation (Testing Only)

For quick testing without GPU support:

```bash
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install coqui-tts sounddevice PyQt6 fastapi uvicorn pyyaml
# Still need to install espeak-ng system package
```

## Dependency Version Constraints

### Pinned Versions

These are the **minimum** versions tested:

```
torch>=2.0.0
coqui-tts>=0.24.0
PyQt6>=6.5.0
fastapi>=0.100.0
phonemizer>=3.2.0
```

### Flexible Versions

These can use latest stable:

```
numpy>=1.24.0
scipy>=1.10.0
librosa>=0.10.0
pandas>=2.0.0
```

### Known Incompatibilities

- **NumPy 2.0:** Not fully compatible with some audio libraries yet - use NumPy 1.x
- **Python 3.13:** Dependencies not ready - use Python 3.10-3.12
- **PyAudio + Python 3.12:** No official wheels - use `sounddevice` instead

## Verification Commands

After installation, verify your setup:

```python
import sys
import torch
import TTS
from PyQt6 import QtCore
import sounddevice as sd

print(f"Python: {sys.version}")
print(f"PyTorch: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU: {torch.cuda.get_device_name(0)}")
print(f"TTS: {TTS.__version__}")
print(f"PyQt6: {QtCore.PYQT_VERSION_STR}")
print(f"\nAudio devices:")
print(sd.query_devices())
```

Expected output:
```
Python: 3.11.x
PyTorch: 2.7.x
CUDA available: True
CUDA version: 12.6
GPU: NVIDIA GeForce RTX 4090
TTS: 0.24.2
PyQt6: 6.10.0

Audio devices:
  0 Microsoft Sound Mapper - Input, MME (2 in, 0 out)
  1 Microphone (Realtek High Defini, MME (2 in, 0 out)
  ...
```

## Update Frequency

This document is maintained for compatibility with:
- Latest stable Python releases (currently 3.10-3.12)
- Latest PyTorch stable release
- Latest dependency versions as of **December 2025**

Check back quarterly or when encountering installation issues.

## Resources

- [PyTorch Compatibility Matrix](https://github.com/pytorch/pytorch/blob/main/RELEASE.md)
- [Coqui TTS Fork](https://github.com/idiap/coqui-ai-TTS)
- [PyQt6 Releases](https://riverbankcomputing.com/news)
- [Python Release Schedule](https://peps.python.org/pep-0619/)