# Contributing to VoiceClone Studio

Thank you for your interest in contributing to VoiceClone Studio! This document provides guidelines and information for contributors.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/Fizzolas/VoiceClone-Studio/issues)
2. If not, create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - System information (OS, Python version, GPU, etc.)
   - Error messages and logs

### Suggesting Features

1. Check [Discussions](https://github.com/Fizzolas/VoiceClone-Studio/discussions) for similar suggestions
2. Create a new discussion with:
   - Clear description of the feature
   - Use cases and benefits
   - Potential implementation approach (if applicable)

### Contributing Code

#### Setup Development Environment

```bash
# Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/VoiceClone-Studio.git
cd VoiceClone-Studio

# Create virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install development dependencies
pip install -r requirements-dev.txt

# Install pre-commit hooks
pre-commit install
```

#### Development Workflow

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

2. **Make your changes**
   - Write clean, documented code
   - Follow the coding standards (see below)
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes**
   ```bash
   # Run tests
   pytest tests/
   
   # Check code style
   black src/
   flake8 src/
   
   # Type checking
   mypy src/
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature" # or "fix: resolve bug"
   ```
   
   Use conventional commit messages:
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `style:` Code formatting
   - `refactor:` Code refactoring
   - `test:` Adding tests
   - `chore:` Maintenance tasks

5. **Push and create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```
   
   Then create a PR on GitHub with:
   - Clear description of changes
   - Reference to related issues
   - Screenshots/demos (if applicable)

## Coding Standards

### Python Style Guide

- Follow [PEP 8](https://peps.python.org/pep-0008/)
- Use [Black](https://black.readthedocs.io/) for formatting (line length: 100)
- Use [type hints](https://docs.python.org/3/library/typing.html) for function signatures
- Write docstrings for all public functions/classes (Google style)

### Example

```python
from typing import List, Optional

def process_audio(
    audio_path: str,
    sample_rate: int = 22050,
    normalize: bool = True
) -> Optional[List[float]]:
    """Process audio file and return samples.
    
    Args:
        audio_path: Path to audio file
        sample_rate: Target sample rate in Hz
        normalize: Whether to normalize audio levels
        
    Returns:
        List of audio samples, or None if processing failed
        
    Raises:
        FileNotFoundError: If audio file doesn't exist
        ValueError: If sample rate is invalid
    """
    # Implementation
    pass
```

### Documentation

- Update README.md for user-facing changes
- Add docstrings to all public APIs
- Update API documentation for API changes
- Include code examples where helpful

### Testing

- Write unit tests for new functions
- Write integration tests for new features
- Maintain test coverage above 80%
- Test on multiple platforms if possible (Windows, Linux, macOS)

## Project Structure

When adding new files, follow this organization:

```
src/
├── gui/              # GUI components
├── models/           # ML models and training
├── audio/            # Audio processing
├── api/              # REST API
└── utils/            # Utility functions
```

## Review Process

1. All PRs require at least one approval
2. CI checks must pass (tests, linting)
3. Code should be reviewed for:
   - Correctness
   - Code quality
   - Performance
   - Security
   - Documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Feel free to:
- Open a [Discussion](https://github.com/Fizzolas/VoiceClone-Studio/discussions)
- Ask in pull request comments
- Contact maintainers

Thank you for contributing! 🎉