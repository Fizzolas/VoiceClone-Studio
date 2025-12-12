# Branch Guide

This document describes the branching strategy and workflow for VoiceClone Studio.

## Branch Structure

### 🌿 Main Branches

#### `main`
**Purpose**: Production-ready code

- Always stable and deployable
- Contains released versions
- Protected branch (requires PR and review)
- Tagged with version numbers (e.g., `v0.1.0-alpha`)
- Direct commits not allowed

**Current Status**: v0.1.0-alpha - Initial repository setup

---

#### `develop`
**Purpose**: Integration branch for ongoing development

- Contains latest development changes
- Features are merged here first
- May be unstable
- Periodically merged to `main` for releases
- All feature branches branch from here

**Current Status**: Ready for feature development

---

### 🌱 Supporting Branches

#### Feature Branches
**Naming**: `feature/<feature-name>`

**Purpose**: Develop new features

**Workflow**:
```bash
# Create from develop
git checkout develop
git pull origin develop
git checkout -b feature/amazing-feature

# Work on feature
git add .
git commit -m "feat: add amazing feature"

# Push and create PR to develop
git push origin feature/amazing-feature
```

**Examples**:
- `feature/gui-implementation` - GUI development
- `feature/model-training` - Training pipeline
- `feature/api-endpoints` - REST API implementation
- `feature/singing-mode` - Singing voice generation

**Delete after**: Merged to develop

---

#### Bugfix Branches
**Naming**: `bugfix/<bug-description>` or `fix/<bug-description>`

**Purpose**: Fix bugs in develop branch

**Workflow**:
```bash
git checkout develop
git checkout -b bugfix/fix-audio-crash
# Fix bug
git commit -m "fix: resolve audio device crash"
git push origin bugfix/fix-audio-crash
# PR to develop
```

---

#### Hotfix Branches
**Naming**: `hotfix/<version>`

**Purpose**: Critical fixes for production (main branch)

**Workflow**:
```bash
git checkout main
git checkout -b hotfix/0.1.1
# Fix critical issue
git commit -m "fix: critical security vulnerability"
# PR to BOTH main and develop
```

**Special**: Merged to both `main` and `develop`

---

#### Release Branches
**Naming**: `release/<version>`

**Purpose**: Prepare for new production release

**Workflow**:
```bash
git checkout develop
git checkout -b release/0.2.0
# Final testing, version bumps, changelog updates
git commit -m "chore: prepare release 0.2.0"
# PR to main, then merge back to develop
```

---

## Current Active Branches

### 💚 Production
- **main** (v0.1.0-alpha)
  - Initial repository setup
  - Documentation and project structure
  - Installation scripts

### 🟡 Development
- **develop**
  - Ready for feature development
  - No active work yet

### 🔵 Feature Branches
- **feature/gui-implementation**
  - 🚧 Ready for development
  - Goal: Implement PyQt6 GUI components
  - Assignee: TBD
  
- **feature/model-training**
  - 🚧 Ready for development
  - Goal: Implement voice training pipeline
  - Assignee: TBD

---

## Commit Message Convention

We use [Conventional Commits](https://www.conventionalcommits.org/) for clear history:

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting (no logic change)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes

### Examples
```bash
feat(gui): add voice profile selector
feat(training): implement real-time audio processing
fix(audio): resolve microphone device detection
docs(readme): update installation instructions
refactor(api): simplify endpoint structure
test(training): add unit tests for audio preprocessing
chore(deps): update PyTorch to 2.7.0
```

### Breaking Changes
```bash
feat(api)!: change authentication endpoint

BREAKING CHANGE: /api/auth is now /api/v1/authenticate
```

---

## Pull Request Workflow

### 1. Create Feature Branch
```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-feature
```

### 2. Develop and Commit
```bash
# Make changes
git add .
git commit -m "feat(scope): description"
```

### 3. Keep Up to Date
```bash
git fetch origin
git rebase origin/develop
```

### 4. Push and Create PR
```bash
git push origin feature/my-feature
# Create PR on GitHub to develop branch
```

### 5. Review Process
- Automated checks must pass (tests, linting)
- At least one approval required
- Address review comments
- Squash or rebase before merge

### 6. After Merge
```bash
git checkout develop
git pull origin develop
git branch -d feature/my-feature
git push origin --delete feature/my-feature
```

---

## Release Workflow

### Version Numbering
We follow [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes (1.0.0, 2.0.0)
- **MINOR**: New features, backward compatible (0.2.0, 0.3.0)
- **PATCH**: Bug fixes, backward compatible (0.1.1, 0.1.2)
- **Pre-release**: alpha, beta, rc (0.1.0-alpha, 0.2.0-beta.1)

### Release Process

1. **Create Release Branch**
   ```bash
   git checkout develop
   git checkout -b release/0.2.0
   ```

2. **Update Version and Changelog**
   - Update version in `setup.py`, `__init__.py`, etc.
   - Update `CHANGELOG.md`
   - Final testing

3. **Merge to Main**
   ```bash
   # Create PR to main
   # After merge:
   git checkout main
   git tag -a v0.2.0 -m "Release version 0.2.0"
   git push origin v0.2.0
   ```

4. **Merge Back to Develop**
   ```bash
   git checkout develop
   git merge release/0.2.0
   git push origin develop
   ```

5. **Delete Release Branch**
   ```bash
   git branch -d release/0.2.0
   git push origin --delete release/0.2.0
   ```

6. **Create GitHub Release**
   - Go to GitHub Releases
   - Draft new release from tag
   - Add release notes from CHANGELOG
   - Publish release

---

## Branch Protection Rules

### `main` Branch
- ✅ Require pull request before merging
- ✅ Require at least 1 approval
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ✅ Require conversation resolution
- ❌ No force pushes
- ❌ No deletions

### `develop` Branch
- ✅ Require pull request before merging
- ✅ Require status checks to pass
- ⚠️ Approval optional (for faster iteration)
- ❌ No force pushes (unless rebasing)

---

## Useful Commands

### View All Branches
```bash
# Local branches
git branch

# Remote branches
git branch -r

# All branches
git branch -a
```

### Clean Up Merged Branches
```bash
# Delete local branches merged to develop
git branch --merged develop | grep -v "\* develop" | xargs -n 1 git branch -d

# Delete remote tracking branches
git fetch --prune
```

### Switch Between Branches
```bash
git checkout main
git checkout develop
git checkout feature/gui-implementation
```

### View Branch History
```bash
git log --oneline --graph --all
```

---

## FAQ

**Q: Which branch should I base my PR on?**
A: Almost always `develop`. Only use `main` for critical hotfixes.

**Q: Can I commit directly to develop?**
A: No, all changes must go through pull requests.

**Q: How often is develop merged to main?**
A: When we're ready for a release (roughly every 1-2 months).

**Q: What if I need to update my branch?**
A: Rebase on develop: `git rebase origin/develop`

**Q: My PR has conflicts, what do I do?**
A: Rebase on the target branch and resolve conflicts locally.

---

## Resources

- [Git Flow Workflow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

---

For questions, see [CONTRIBUTING.md](CONTRIBUTING.md) or ask in [Discussions](https://github.com/Fizzolas/VoiceClone-Studio/discussions).