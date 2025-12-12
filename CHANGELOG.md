# Changelog

All notable changes to VoiceClone Studio will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned Features
- Singing voice generation with MIDI input
- Mobile app (iOS/Android)
- Real-time voice conversion
- Multi-language interface (Spanish, French, German, Chinese, Japanese)
- Voice aging/de-aging effects
- Cloud training support

---

## [0.1.0-alpha] - 2025-12-12

### Added
- **Initial repository setup** with complete project structure
- **Comprehensive README** with feature overview and installation guide
- **Cross-platform installation scripts** (Windows `.bat` and Unix `.sh`)
- **Configuration system** with `config.yaml` template
- **Professional documentation structure**:
  - TROUBLESHOOTING.md - Common issues and solutions
  - INSTALLATION_NOTES.md - Detailed compatibility information
  - CONTRIBUTING.md - Contribution guidelines
- **Package management**:
  - requirements.txt with all dependencies
  - requirements-dev.txt for development tools
- **MIT License** for open-source distribution
- **Support for latest technologies**:
  - PyTorch 2.7 with CUDA 12.6 support
  - Python 3.10-3.12 compatibility
  - Coqui TTS fork with Python 3.12+ support
  - GPU acceleration (NVIDIA CUDA, AMD ROCm, Apple Metal)
- **Audio processing foundation**:
  - Multiple input methods (live recording, file upload, text reading)
  - Support for WAV, MP3, FLAC, OGG formats
  - Automatic silence detection and noise reduction
  - Background buffer for continuous processing
- **API framework** for external AI integration
- **Modular architecture** with clear separation of concerns:
  - GUI components (PyQt6)
  - Model training and inference
  - Audio processing pipeline
  - REST API server
  - Utility functions

### Fixed
- **Dependency compatibility issues** for December 2025:
  - Updated PyTorch CUDA version from 11.8 to 12.6
  - Switched from deprecated `TTS` package to maintained `coqui-tts` fork
  - Added platform-specific installation methods for PyAudio
  - Included espeak-ng installation instructions
- **Installation script improvements**:
  - Automatic GPU detection and appropriate PyTorch version selection
  - System dependency checks (espeak-ng, portaudio)
  - Better error messages with actionable solutions
  - Fallback options for problematic dependencies
- **Python version constraints**:
  - Explicitly support Python 3.10, 3.11, 3.12
  - Document Python 3.13 incompatibility

### Changed
- **Default audio library**: Switched from PyAudio to sounddevice for easier installation
- **Installation workflow**: PyTorch installed before other dependencies to prevent conflicts
- **Documentation structure**: Reorganized for better user experience

### Technical Details
- **Base models**: XTTS v2 / Coqui TTS for voice synthesis
- **Voice encoding**: Speaker encoder for voice characteristics
- **Audio framework**: PyTorch audio transforms and librosa
- **GUI framework**: PyQt6 for cross-platform interface
- **API framework**: FastAPI with async support
- **Minimum requirements**:
  - Python 3.10+
  - 4GB RAM (8GB recommended)
  - 2GB disk space
  - Optional: NVIDIA GPU with 4GB+ VRAM

### Known Issues
- GUI implementation pending (framework in place)
- Model training logic to be implemented
- API endpoints need implementation
- Desktop shortcut creation script is placeholder
- Model download script is placeholder

### Development Notes
- Project uses conventional commits for changelog generation
- Pre-commit hooks configured for code quality
- Test framework (pytest) included but tests pending
- Documentation follows Google style docstrings

---

## Release Schedule

### Version 0.2.0 (Target: Q1 2026)
- ✅ Functional GUI implementation
- ✅ Basic voice training pipeline
- ✅ Voice generation (text-to-speech)
- ✅ Audio file upload and processing
- ✅ Real-time recording

### Version 0.3.0 (Target: Q2 2026)
- ✅ AI conversation mode for training
- ✅ REST API implementation
- ✅ Multiple voice profile management
- ✅ Training progress visualization
- ✅ Model quality metrics

### Version 0.4.0 (Target: Q2 2026)
- ✅ Singing voice generation (beta)
- ✅ Emotion control
- ✅ Voice mixing capabilities
- ✅ Export/import models

### Version 1.0.0 (Target: Q3 2026)
- ✅ Production-ready release
- ✅ Complete feature set
- ✅ Comprehensive testing
- ✅ Full documentation
- ✅ Performance optimizations

---

## Migration Guides

### From alpha to beta (when available)
No migration needed - alpha is initial release.

---

## Support

For questions about specific releases:
- [GitHub Issues](https://github.com/Fizzolas/VoiceClone-Studio/issues)
- [GitHub Discussions](https://github.com/Fizzolas/VoiceClone-Studio/discussions)

---

## Contributors

Thank you to all contributors who helped with this release!

- [@Fizzolas](https://github.com/Fizzolas) - Project Creator

See [CONTRIBUTING.md](CONTRIBUTING.md) to join the team!

---

[Unreleased]: https://github.com/Fizzolas/VoiceClone-Studio/compare/v0.1.0-alpha...HEAD
[0.1.0-alpha]: https://github.com/Fizzolas/VoiceClone-Studio/releases/tag/v0.1.0-alpha