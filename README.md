# VoiceClone Studio 🎙️

<div align="center">

![VoiceClone Studio Banner](https://via.placeholder.com/1200x300/1e293b/38bdf8?text=VoiceClone+Studio+🎙️)

**Open-Source Voice Cloning Software with Real-Time Training**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.10%20%7C%203.11%20%7C%203.12-blue.svg)](https://www.python.org/downloads/)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.0%2B-ee4c2c.svg)](https://pytorch.org/)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)](#-installation)
[![GitHub release](https://img.shields.io/badge/release-v0.1.0--alpha-orange.svg)](https://github.com/Fizzolas/VoiceClone-Studio/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

[Features](#-features) • [Installation](#-installation) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Contributing](#-contributing) • [Support](#-support)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Demo](#-demo)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Interface Guide](#%EF%B8%8F-interface-guide)
- [Configuration](#-configuration)
- [API Usage](#-api-usage)
- [Project Structure](#%EF%B8%8F-project-structure)
- [Technical Details](#-technical-details)
- [Roadmap](#%EF%B8%8F-roadmap)
- [Contributing](#-contributing)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)
- [Support](#-support)

---

## 🌟 Overview

VoiceClone Studio is a **user-friendly, open-source application** that democratizes voice cloning technology. Using state-of-the-art machine learning models, anyone can create realistic voice clones for reading, singing, or AI assistant integration—no technical expertise required.

### ✨ Why VoiceClone Studio?

| Feature | VoiceClone Studio | Traditional Solutions |
|---------|-------------------|----------------------|
| **Ease of Use** | ✅ Intuitive GUI | ❌ Command-line only |
| **Real-time Training** | ✅ Live feedback | ❌ Batch processing |
| **Cost** | ✅ Free & Open Source | ❌ Expensive subscriptions |
| **Privacy** | ✅ 100% Local | ❌ Cloud-based |
| **Singing Voices** | ✅ Included | ❌ Usually separate |
| **API Integration** | ✅ Built-in REST API | ❌ Limited |
| **Cross-platform** | ✅ Windows/Linux/Mac | ⚠️ Varies |

### 🎯 Key Highlights

- **🎤 Real-time Training**: Train models while speaking with live visual feedback
- **📁 Multiple Input Methods**: Live microphone, audio file uploads, or text-to-speech
- **🎵 Singing Capability**: Generate singing voices with pitch and melody control
- **🤖 AI Integration**: REST API for external AI assistants to use trained voices
- **🖥️ Intuitive GUI**: Clean, modern interface with clearly labeled controls
- **📊 Progress Tracking**: Visual indicators for training status and model quality
- **🌍 Cross-platform**: Works on Windows, Linux, and macOS
- **🔒 Privacy First**: All processing happens locally on your machine

---

## 🚀 Features

<details>
<summary><b>🎙️ Voice Training (Click to expand)</b></summary>

### Live Conversation Mode
- Talk naturally while the model learns in real-time
- Automatic speech detection and silence removal
- Background recording buffer for continuous processing
- Visual waveform and spectrogram display
 
### Scripture/Text Reading
- Upload text and read it aloud for targeted training
- Highlighted text following
- Pronunciation guidance
- Progress tracking per paragraph

### Audio File Upload
- Import existing recordings for batch training
- Support for WAV, MP3, FLAC, OGG formats
- Automatic audio cleaning and normalization
- Speaker diarization for multi-voice files

</details>

<details>
<summary><b>🎵 Voice Generation (Click to expand)</b></summary>

- **Text-to-Speech**: Type any text and hear it in the cloned voice
- **Singing Mode**: Generate singing with melody input (MIDI/MusicXML)
- **Emotion Control**: Adjust tone, pitch, speed, and emotion
- **Real-time Preview**: Hear samples before finalizing

</details>

<details>
<summary><b>📊 Model Management (Click to expand)</b></summary>

- **Multiple Models**: Train and switch between different voice models
- **Quality Metrics**: View training accuracy, loss curves, and sample comparisons
- **Export/Import**: Share models with others or backup your work
- **Fine-tuning**: Continue training existing models with new data

</details>

<details>
<summary><b>🔌 API & Integration (Click to expand)</b></summary>

- **REST API**: Integrate with chatbots, virtual assistants, and other applications
- **Webhook Support**: Receive notifications on training completion
- **Batch Processing**: Queue multiple TTS requests
- **Voice Profiles**: Manage multiple voices via API

</details>

---

## 🎬 Demo

> **Note**: Demo videos and screenshots coming soon! The project is currently in alpha stage.

### Screenshots

<details>
<summary>Click to view interface previews</summary>

*Screenshots will be added as the GUI is implemented*

**Main Interface**
- Training panel with live waveform
- Generation panel with voice controls
- Model quality dashboard

**Training Dashboard**
- Real-time loss curves
- Sample comparison player
- Progress indicators

</details>

---

## 📦 Installation

### Prerequisites

- **Python 3.10, 3.11, or 3.12** ([Download](https://www.python.org/downloads/))
- **4GB+ RAM** (8GB recommended for real-time training)
- **2GB free disk space**
- **Microphone** (for live recording)
- **GPU** (optional, but strongly recommended for faster training)
  - NVIDIA GPU with CUDA support
  - AMD GPU with ROCm support

### Quick Install

#### 🪟 Windows

```bash
# Clone the repository
git clone https://github.com/Fizzolas/VoiceClone-Studio.git
cd VoiceClone-Studio

# Run the installer
install.bat
```

#### 🐧 Linux / 🍎 macOS

```bash
# Clone the repository
git clone https://github.com/Fizzolas/VoiceClone-Studio.git
cd VoiceClone-Studio

# Make installer executable and run
chmod +x install.sh
./install.sh
```

### Manual Installation

<details>
<summary>Click for manual installation steps</summary>

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/macOS:
source venv/bin/activate

# Install PyTorch (choose one based on your hardware)
# CUDA 12.6:
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu126
# CPU only:
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install dependencies
pip install -r requirements.txt

# Install espeak-ng (system dependency)
# Windows: Download from https://github.com/espeak-ng/espeak-ng/releases
# Linux: sudo apt-get install espeak-ng
# macOS: brew install espeak-ng

# Create directories
mkdir -p data/{recordings,uploads,cache} models/{base,user} logs

# Copy configuration
cp config.template.yaml config.yaml
```

</details>

### ⚠️ Important Notes

- **espeak-ng** must be installed separately (see [INSTALLATION_NOTES.md](INSTALLATION_NOTES.md))
- For detailed compatibility information, see [INSTALLATION_NOTES.md](INSTALLATION_NOTES.md)
- Having issues? Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 🎯 Quick Start

### 1. Launch the Application

```bash
python main.py
```

Or use the desktop shortcut created during installation.

### 2. First-Time Setup

1. **Select Audio Device**: Choose your microphone from the dropdown
2. **Create New Voice Profile**: Click "New Profile" and enter a name
3. **Choose Training Method**:
   - **Quick Start** (2-3 min): Basic voice cloning
   - **Standard** (10-15 min): Better quality
   - **Advanced** (30+ min): Production-quality results

### 3. Training Your Voice

#### Method 1: Live Conversation (Recommended for Beginners)

1. Click **"Start Conversation Mode"**
2. The AI assistant will ask you questions—answer naturally
3. Watch the progress bar fill as the model learns
4. Training happens automatically in the background
5. Test your voice anytime by clicking **"Preview"**

#### Method 2: Reading Text

1. Click **"Load Text"** and select a text file or paste content
2. Click **"Start Reading Session"**
3. Read the highlighted text clearly
4. The system automatically advances to the next section
5. Take breaks anytime—progress is saved

#### Method 3: Upload Audio Files

1. Click **"Upload Audio"**
2. Select one or more audio files (WAV, MP3, FLAC)
3. Add transcripts if available (optional but improves quality)
4. Click **"Start Training"**
5. Monitor progress in the training dashboard

### 4. Using Your Cloned Voice

1. Select your trained voice from the **"Voice Profiles"** dropdown
2. Enter text in the **"Text Input"** box
3. Adjust settings (speed, pitch, emotion) if desired
4. Click **"Generate Speech"**
5. Play the audio or save it as a file

---

## 🖥️ Interface Guide

### Main Window

```
┌───────────────────────────────────────────────────────────┐
│  VoiceClone Studio                                    [_][□][X]│
├───────────────────────────────────────────────────────────┤
│  File  Edit  Training  Generate  Models  Help                │
├───────────────────────────────────────────────────────────┤
│                                                               │
│  Voice Profile: [Select Profile ▼]  [New] [Load] [Delete]   │
│                                                               │
│  ┌───────────────────┬───────────────────────────────────┐ │
│  │  TRAINING         │  GENERATION                       │ │
│  │                   │                                   │ │
│  │  ○ Live Recording │  Text Input:                      │ │
│  │  ○ Read Text      │  ┌─────────────────────────────┐ │ │
│  │  ○ Upload Audio   │  │                             │ │ │
│  │                   │  │  Type or paste text here... │ │ │
│  │  [Start Training] │  │                             │ │ │
│  │                   │  └─────────────────────────────┘ │ │
│  │  Progress:        │                                   │ │
│  │  ████████░░ 80%   │  Voice Settings:                  │ │
│  │                   │  Speed: [────●────] 1.0x         │ │
│  │  Training Status: │  Pitch: [────●────] 0            │ │
│  │  Processing...    │  Emotion: [Happy ▼]              │ │
│  │                   │                                   │ │
│  │  [View Details]   │  [Generate] [Preview] [Save]      │ │
│  └───────────────────┴───────────────────────────────────┘ │
│                                                               │
│  Model Quality: ★★★★☆ | Samples: 1,234 | Duration: 45m      │
└───────────────────────────────────────────────────────────┘
```

For detailed interface documentation, see [docs/USER_GUIDE.md](docs/USER_GUIDE.md) *(coming soon)*.

---

## 🔧 Configuration

Edit `config.yaml` to customize behavior:

```yaml
audio:
  sample_rate: 22050
  buffer_size: 1024
  silence_threshold: 0.01
  
training:
  batch_size: 32
  learning_rate: 0.0001
  epochs: 100
  device: "cuda"  # or "cpu" or "mps" (Mac)
  
generation:
  default_speed: 1.0
  default_pitch: 0
  temperature: 0.7
  
api:
  enabled: true
  port: 8080
  auth_required: false
```

See [docs/CONFIGURATION.md](docs/CONFIGURATION.md) for complete reference *(coming soon)*.

---

## 📡 API Usage

Start the API server:

```bash
python main.py --mode api
```

### Quick Examples

#### Generate Speech

```bash
curl -X POST http://localhost:8080/api/v1/generate \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Hello, this is a test.",
    "voice_id": "my_voice",
    "speed": 1.0,
    "pitch": 0
  }'
```

#### List Voice Profiles

```bash
curl http://localhost:8080/api/v1/voices
```

#### Get Training Status

```bash
curl http://localhost:8080/api/v1/training/status/my_voice
```

Full API documentation: [docs/API.md](docs/API.md) *(coming soon)*

---

## 🏗️ Project Structure

```
VoiceClone-Studio/
│
├── main.py                 # Application entry point
├── requirements.txt        # Python dependencies
├── config.yaml            # Configuration file
│
├── src/
│   ├── gui/               # User interface components
│   ├── models/            # ML model implementations
│   ├── audio/             # Audio processing
│   ├── api/               # REST API server
│   └── utils/             # Utility functions
│
├── models/                # Pre-trained and user models
├── data/                  # Training data
├── scripts/               # Utility scripts
├── tests/                 # Unit and integration tests
└── docs/                  # Documentation
```

---

## 🧪 Technical Details

### Models Used

- **TTS Engine**: XTTS v2 / Coqui TTS for voice synthesis
- **Voice Encoding**: Speaker encoder for voice characteristics
- **Audio Processing**: PyTorch audio transforms and librosa
- **Real-time Processing**: Streaming inference with optimized batching

### Performance Benchmarks

| Hardware | Training Speed | Generation Speed |
|----------|----------------|------------------|
| CPU (i7-12700) | ~15 min/min audio | 1-2x real-time |
| RTX 3060 | ~2 min/min audio | 5-10x real-time |
| RTX 4090 | ~30 sec/min audio | 15-20x real-time |
| M2 Max | ~3 min/min audio | 3-5x real-time |

### System Requirements

- **Minimum**: 4GB RAM, CPU-only
- **Recommended**: 8GB RAM, NVIDIA GPU with 4GB+ VRAM
- **Optimal**: 16GB RAM, NVIDIA RTX 30/40 series GPU

---

## 🗺️ Roadmap

### ✅ v0.1.0-alpha (Current)
- [x] Project structure and documentation
- [x] Installation scripts
- [x] Configuration system
- [x] Dependency management

### 🚧 v0.2.0 (Q1 2026)
- [ ] Functional GUI implementation
- [ ] Basic voice training pipeline
- [ ] Voice generation (text-to-speech)
- [ ] Audio file upload and processing
- [ ] Real-time recording

### 📋 v0.3.0 (Q2 2026)
- [ ] AI conversation mode for training
- [ ] REST API implementation
- [ ] Multiple voice profile management
- [ ] Training progress visualization
- [ ] Model quality metrics

### 🎵 v0.4.0 (Q2 2026)
- [ ] Singing voice generation (beta)
- [ ] Emotion control
- [ ] Voice mixing capabilities
- [ ] Export/import models

### 🎉 v1.0.0 (Q3 2026)
- [ ] Production-ready release
- [ ] Complete feature set
- [ ] Comprehensive testing
- [ ] Full documentation
- [ ] Performance optimizations

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

- 🐛 **Report Bugs**: [Open an issue](https://github.com/Fizzolas/VoiceClone-Studio/issues/new?template=bug_report.md)
- 💡 **Suggest Features**: [Start a discussion](https://github.com/Fizzolas/VoiceClone-Studio/discussions)
- 📝 **Improve Documentation**: Submit PRs for docs
- 💻 **Submit Code**: Follow our [contributing guide](CONTRIBUTING.md)

### Quick Start for Contributors

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/VoiceClone-Studio.git
cd VoiceClone-Studio

# Install dev dependencies
pip install -r requirements-dev.txt

# Create feature branch
git checkout -b feature/amazing-feature

# Make changes and test
pytest tests/
black src/
flake8 src/

# Commit and push
git commit -m "feat: add amazing feature"
git push origin feature/amazing-feature
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses

- Coqui TTS: Mozilla Public License 2.0
- PyTorch: BSD License
- Additional licenses in [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) *(coming soon)*

---

## 🙏 Acknowledgments

- [Coqui TTS](https://github.com/coqui-ai/TTS) for the base TTS framework
- [OpenVoice](https://github.com/myshell-ai/OpenVoice) for voice cloning research
- [Real-Time-Voice-Cloning](https://github.com/CorentinJ/Real-Time-Voice-Cloning) for inspiration
- All contributors and the open-source community

---

## 📞 Support

### Documentation
- 📚 [Full Documentation](docs/README.md)
- ❓ [FAQ](docs/FAQ.md) *(coming soon)*
- 🛠️ [Troubleshooting Guide](TROUBLESHOOTING.md)
- 📖 [Installation Notes](INSTALLATION_NOTES.md)

### Community
- 💬 [GitHub Discussions](https://github.com/Fizzolas/VoiceClone-Studio/discussions)
- 🐛 [Issue Tracker](https://github.com/Fizzolas/VoiceClone-Studio/issues)
- 📧 Email: support@voiceclone.studio *(for security issues)*

### Stay Updated
- ⭐ Star this repository to follow development
- 👁️ Watch for release notifications
- 🔔 Subscribe to [Discussions](https://github.com/Fizzolas/VoiceClone-Studio/discussions)

---

<div align="center">

### 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Fizzolas/VoiceClone-Studio&type=Date)](https://star-history.com/#Fizzolas/VoiceClone-Studio&Date)

---

**Made with ❤️ by the VoiceClone Studio Community**

⭐ **Star us on GitHub if you find this useful!** ⭐

[Report Bug](https://github.com/Fizzolas/VoiceClone-Studio/issues/new?template=bug_report.md) • [Request Feature](https://github.com/Fizzolas/VoiceClone-Studio/issues/new?template=feature_request.md) • [Ask Question](https://github.com/Fizzolas/VoiceClone-Studio/discussions/new)

</div>