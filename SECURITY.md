# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please follow these steps:

### 1. Do Not Publicly Disclose

**Please do not** open a public GitHub issue or discuss the vulnerability in public forums until it has been addressed.

### 2. Report Privately

Send a detailed report to: **security@voiceclone.studio**

Include the following information:
- Type of vulnerability
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue and how an attacker might exploit it

### 3. What to Expect

- **Acknowledgment**: We will acknowledge receipt of your report within 48 hours
- **Communication**: We will send you regular updates about our progress
- **Timeline**: We aim to patch critical vulnerabilities within 7 days
- **Credit**: We will credit you in the security advisory (unless you prefer to remain anonymous)

### 4. Disclosure Policy

Once a vulnerability is patched:
1. We will publish a security advisory on GitHub
2. We will credit the reporter (unless anonymity is requested)
3. We will release a patch version with the fix
4. We will notify users via GitHub releases and discussions

## Security Best Practices for Users

### When Using VoiceClone Studio

1. **Keep Software Updated**: Always use the latest version
2. **Virtual Environment**: Run in a Python virtual environment
3. **API Security**: 
   - Enable authentication if exposing the API (`api.auth_required: true`)
   - Use strong API keys
   - Don't expose the API to the internet without proper security
4. **File Uploads**: Be cautious when uploading audio files from untrusted sources
5. **Model Sharing**: Only load voice models from trusted sources

### When Hosting the API

1. **HTTPS**: Use HTTPS for all API communications
2. **Rate Limiting**: Configure appropriate rate limits
3. **Authentication**: Always require API authentication in production
4. **CORS**: Restrict CORS origins to trusted domains
5. **Firewall**: Use a firewall to restrict access
6. **Monitoring**: Monitor API usage for suspicious activity

### Privacy Considerations

1. **Local Processing**: All voice cloning happens locally—no data is sent to external servers
2. **Model Storage**: Voice models are stored locally in `models/user/`
3. **Recording Storage**: Audio recordings are stored in `data/recordings/`
4. **Data Deletion**: Delete old recordings and models you no longer need

## Known Security Considerations

### Current Version (0.1.0-alpha)

- ⚠️ **Alpha Software**: This is alpha software and has not undergone security auditing
- ⚠️ **API Authentication**: API authentication is disabled by default—enable for production use
- ⚠️ **File Validation**: Limited validation of uploaded audio files—be cautious with untrusted sources

### Future Improvements

- 🔒 Security audit before v1.0 release
- 🔒 Enhanced input validation for audio files
- 🔒 Sandboxing for model inference
- 🔒 Two-factor authentication for API
- 🔒 Encrypted model storage option

## Security Dependencies

We regularly update dependencies to address security vulnerabilities:

- PyTorch and related ML libraries
- FastAPI and web framework dependencies
- Audio processing libraries

Dependabot is enabled to automatically create PRs for dependency updates.

## Hall of Fame

We recognize security researchers who responsibly disclose vulnerabilities:

*No reports yet - be the first!*

## Contact

- **Security Issues**: security@voiceclone.studio
- **General Support**: support@voiceclone.studio
- **GitHub Issues**: https://github.com/Fizzolas/VoiceClone-Studio/issues (non-security issues only)

---

Thank you for helping keep VoiceClone Studio and our users safe!