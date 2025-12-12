# VoiceClone Studio - Troubleshooting Guide

This guide covers common installation and runtime issues with solutions.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Runtime Errors](#runtime-errors)
- [Audio Issues](#audio-issues)
- [Performance Issues](#performance-issues)
- [Platform-Specific Issues](#platform-specific-issues)

---

## Installation Issues

### Python Version Compatibility

**Problem:** Installation fails with "Python version not supported"

**Solution:**
- VoiceClone Studio requires **Python 3.10, 3.11, or 3.12**
- Python 3.13 is not yet fully supported by all dependencies
- Check your version: `python --version`
- Download Python from [python.org](https://www.python.org/downloads/)

### Coqui TTS Installation Fails

**Problem:** `ERROR: Could not find a version that satisfies the requirement TTS`

**Solution:**
```bash
# The original Coqui TTS project is discontinued
# We use the maintained fork that supports Python 3.12+
pip install coqui-tts

# If that fails, try:
pip install coqui-tts --no-deps
pip install -r requirements.txt
```

**Background:** The original `TTS` package only supports Python < 3.12. The `coqui-tts` package is a maintained fork by Idiap Research Institute that adds Python 3.12+ support[^1].

### espeak-ng Not Found

**Problem:** `phonemizer` fails with "espeak-ng not found" or "backend not available"

**Solution by Platform:**

**Windows:**
1. Download espeak-ng from [GitHub Releases](https://github.com/espeak-ng/espeak-ng/releases)
2. Install `espeak-ng-X64.msi`
3. Add to PATH: `C:\Program Files\eSpeak NG\`
4. OR set environment variable:
   ```cmd
   set PHONEMIZER_ESPEAK_LIBRARY=C:\Program Files\eSpeak NG\libespeak-ng.dll
   ```

**Linux (Debian/Ubuntu):**
```bash
sudo apt-get update
sudo apt-get install espeak-ng
```

**Linux (RedHat/CentOS/Fedora):**
```bash
sudo yum install espeak-ng
# or
sudo dnf install espeak-ng
```

**macOS:**
```bash
brew install espeak-ng
```

### PyAudio Installation Fails on Windows

**Problem:** `error: Microsoft Visual C++ 14.0 is required`

**Solution (Method 1 - Recommended):**
```bash
# Use precompiled wheel
pip install pipwin
pipwin install pyaudio
```

**Solution (Method 2):**
1. Download precompiled wheel from [Unofficial Windows Binaries](https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio)
2. Choose correct version (e.g., `PyAudio-0.2.11-cp310-cp310-win_amd64.whl` for Python 3.10 64-bit)
3. Install: `pip install path/to/downloaded.whl`

**Solution (Method 3 - Use sounddevice instead):**
```bash
# sounddevice is easier to install and works cross-platform
pip install sounddevice
# Already included in requirements.txt as alternative
```

### PyAudio Installation Fails on Linux

**Problem:** `portaudio.h: No such file or directory`

**Solution:**

**Debian/Ubuntu:**
```bash
sudo apt-get install portaudio19-dev python3-pyaudio
pip install pyaudio
```

**RedHat/CentOS:**
```bash
sudo yum install portaudio-devel
pip install pyaudio
```

**Arch Linux:**
```bash
sudo pacman -S portaudio python-pyaudio
```

### PyTorch CUDA Installation Issues

**Problem:** PyTorch doesn't detect GPU or CUDA errors

**Check your NVIDIA driver version:**
```bash
nvidia-smi
```

**Solutions:**

1. **For CUDA 12.6 (requires driver >= 525.60.13):**
   ```bash
   pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu126
   ```

2. **For older drivers (CUDA 11.8, requires driver >= 450.80.02):**
   ```bash
   pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu118
   ```

3. **CPU only (no GPU):**
   ```bash
   pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu
   ```

**Verify installation:**
```python
import torch
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU: {torch.cuda.get_device_name(0)}")
```

---

## Runtime Errors

### "No module named 'gui'" or "No module named 'src'"

**Problem:** Python can't find the application modules

**Solution:**
Make sure you're running from the project root directory:
```bash
cd VoiceClone-Studio
python main.py
```

If the `src/` directory doesn't exist yet, create the basic structure:
```bash
mkdir -p src/gui src/models src/audio src/api src/utils
touch src/__init__.py src/gui/__init__.py src/models/__init__.py
```

### "TTS model not found" or "Failed to download model"

**Problem:** Base models haven't been downloaded

**Solution:**
```bash
# Models are downloaded automatically on first use
# To manually download:
python -c "from TTS.api import TTS; TTS('tts_models/multilingual/multi-dataset/xtts_v2')"
```

**Model cache location:**
- Linux/macOS: `~/.local/share/tts/`
- Windows: `%USERPROFILE%\AppData\Local\tts\`

### Import Errors After Installation

**Problem:** `ImportError` or `ModuleNotFoundError` even after installation

**Solution:**
1. Make sure virtual environment is activated:
   ```bash
   # Windows
   venv\Scripts\activate
   
   # Linux/macOS
   source venv/bin/activate
   ```

2. Verify packages are installed in the virtual environment:
   ```bash
   pip list | grep -E "torch|TTS|PyQt6"
   ```

3. Reinstall if needed:
   ```bash
   pip install --force-reinstall -r requirements.txt
   ```

---

## Audio Issues

### No Audio Devices Found

**Problem:** "No input/output devices available"

**Solution:**

**Check available devices:**
```python
import sounddevice as sd
print(sd.query_devices())
```

**Windows:**
- Check that microphone is enabled in Windows Sound Settings
- Update audio drivers
- Try running as Administrator

**Linux:**
- Install PulseAudio or PipeWire:
  ```bash
  sudo apt-get install pulseaudio
  # or
  sudo apt-get install pipewire
  ```
- Check permissions for audio group:
  ```bash
  sudo usermod -a -G audio $USER
  # Log out and back in
  ```

**macOS:**
- Grant microphone permissions in System Preferences > Security & Privacy > Microphone

### Audio Crackling or Distortion

**Problem:** Poor audio quality during recording/playback

**Solutions:**
1. Adjust buffer size in `config.yaml`:
   ```yaml
   audio:
     buffer_size: 2048  # Increase from 1024
     chunk_duration: 1.0  # Increase from 0.5
   ```

2. Use a lower sample rate:
   ```yaml
   audio:
     sample_rate: 16000  # Instead of 22050
   ```

3. Close other audio applications
4. Update audio drivers

### "OSError: [Errno -9981] Input overflowed"

**Problem:** Audio buffer overflow during recording

**Solution:**
Increase buffer size in `config.yaml`:
```yaml
audio:
  buffer_size: 2048
  chunk_duration: 1.0
```

---

## Performance Issues

### Slow Training Speed

**Problem:** Training takes too long

**Solutions:**

1. **Use GPU acceleration:**
   - Install CUDA-enabled PyTorch (see above)
   - Verify GPU is being used: Check that `device: cuda` in `config.yaml`

2. **Optimize batch size:**
   ```yaml
   training:
     batch_size: 16  # Reduce if out of memory
     use_mixed_precision: true  # Enable FP16 training
   ```

3. **Reduce audio quality temporarily:**
   ```yaml
   audio:
     sample_rate: 16000  # Lower quality, faster training
   ```

### Out of Memory Errors

**Problem:** `RuntimeError: CUDA out of memory` or system freezes

**Solutions:**

1. **Reduce batch size:**
   ```yaml
   training:
     batch_size: 8  # Or even 4
   ```

2. **Use gradient accumulation:**
   ```yaml
   training:
     batch_size: 4
     gradient_accumulation_steps: 4  # Effective batch size = 16
   ```

3. **Clear GPU cache:**
   ```python
   import torch
   torch.cuda.empty_cache()
   ```

4. **Use CPU instead:**
   ```yaml
   training:
     device: cpu
   ```

### Slow Generation Speed

**Problem:** Voice generation takes too long

**Solutions:**

1. Enable streaming mode:
   ```yaml
   generation:
     streaming: true
   ```

2. Use GPU for generation

3. Reduce temperature for faster sampling:
   ```yaml
   generation:
     default_temperature: 0.5  # Lower = faster but less variation
   ```

---

## Platform-Specific Issues

### Windows

**Long Path Issues:**
Enable long path support:
```cmd
# Run as Administrator
reg add HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1 /f
```

**Permission Errors:**
Run Command Prompt as Administrator or adjust folder permissions

### macOS

**"Python quit unexpectedly" on Apple Silicon:**
Make sure you're using native ARM64 Python, not Rosetta:
```bash
python3 -c "import platform; print(platform.machine())"
# Should print 'arm64' not 'x86_64'
```

**Microphone Permission:**
Grant terminal/IDE microphone access in System Preferences

### Linux

**ALSA Errors:**
```bash
# Install ALSA development files
sudo apt-get install libasound2-dev
```

**"Permission denied" for audio devices:**
```bash
# Add user to audio group
sudo usermod -a -G audio $USER
# Log out and log back in
```

---

## Getting Help

If your issue isn't covered here:

1. Check [GitHub Issues](https://github.com/Fizzolas/VoiceClone-Studio/issues)
2. Search [GitHub Discussions](https://github.com/Fizzolas/VoiceClone-Studio/discussions)
3. Open a new issue with:
   - Your OS and version
   - Python version (`python --version`)
   - Full error message and traceback
   - Steps to reproduce
   - Output of `pip list`

---

## References

- [Coqui TTS Documentation](https://docs.coqui.ai/)
- [PyTorch Installation Guide](https://pytorch.org/get-started/locally/)
- [PyQt6 Documentation](https://www.riverbankcomputing.com/static/Docs/PyQt6/)
- [phonemizer Documentation](https://bootphon.github.io/phonemizer/)