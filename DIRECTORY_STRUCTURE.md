# Directory Structure

This repository is organized into the following directories for better maintainability:

## 📁 Root Directory
- `README.md` - Main project documentation
- `DIRECTORY_STRUCTURE.md` - This file explaining the organization

## 📁 dockerfiles/
Contains all Dockerfile variants for different image types:
- `Dockerfile` - Standard full Kali Linux image
- `Dockerfile.minimal` - Lightweight version
- `Dockerfile.alternative` - Alternative build approach
- `Dockerfile.optimized` - Size-optimized full image
- `Dockerfile.minimal.optimized` - Size-optimized minimal image
- `Dockerfile.ultraslim` - Ultra-minimal VNC-based image

## 📁 scripts/
### 🔧 scripts/build/
Build automation scripts:
- `build-optimized-images.bat` - Interactive builder for optimized images
- `build-push-dockerhub.bat` - Windows batch build and push script
- `build-push-dockerhub.ps1` - PowerShell build and push script
- `build-push-dockerhub.sh` - Linux/macOS build and push script

### 🚀 scripts/push/
Docker registry publishing scripts:
- `push-minimal-optimized.bat` - Push minimal optimized image
- `push-ultraslim.bat` - Push ultra-slim image
- `push-optimized-images.bat` - Push all optimized images
- `push-to-github-packages.ps1` - Push to GitHub Packages
- `push-to-github-packages.bat` - Batch wrapper for GitHub Packages
- `push-direct.bat` - Direct push with logging
- `push-large-images.bat` - Special handling for large images
- `push_log.txt` - Push operation logs

### 🏃 scripts/run/
Container execution scripts:
- `kali-quickstart.bat` - One-click Windows starter
- `run-kali.bat` - Basic Windows run script
- `run-kali-container.ps1` - Advanced PowerShell runner
- `run-from-dockerhub.ps1` - Run pre-built images from Docker Hub

### 🛠️ scripts/utils/
Utility and maintenance scripts:
- `check-image-sizes.bat` - Compare image sizes
- `final-check.bat` - Final verification script
- `verify-setup.bat` - Setup verification
- `test-persistence.sh` - Test data persistence
- `start-xrdp.sh` - XRDP service startup script
- `setup-linux.sh` - Linux environment setup
- `fix-gpg-keys.sh` - GPG key troubleshooting

## 📁 docs/
Project documentation:
- `CHANGELOG.md` - Version history and changes
- `DATA_PERSISTENCE.md` - Data persistence guide
- `DOCKER_HUB_NOTES.md` - Docker Hub publishing notes
- `IMAGE_VARIANTS.md` - Detailed image variant comparisons

## 📁 .github/
GitHub-specific configuration files (workflows, templates, etc.)

## Usage

All scripts maintain their original functionality but are now organized by purpose. You can run them using relative paths:

```bash
# Build optimized images
scripts\build\build-optimized-images.bat

# Quick start
scripts\run\kali-quickstart.bat

# Check image sizes
scripts\utils\check-image-sizes.bat

# Push to Docker Hub
scripts\push\push-minimal-optimized.bat
```

This organization makes it easier to:
- Find the right script for your task
- Maintain and update scripts
- Understand the project structure
- Contribute new features
