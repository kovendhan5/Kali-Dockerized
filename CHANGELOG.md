# CHANGELOG - Kali Docker Enhancements

## Major Improvements

### 1. GPG Key Fix Implementation
- Created `fix-gpg-keys.sh` script that tries multiple approaches to fix key verification issues
- Added fallback mechanisms in case repository verification fails
- Modified Dockerfile to properly handle insecure repositories temporarily during build

### 2. Multiple Dockerfile Variants
- `Dockerfile` - Full Kali installation with penetration testing tools
- `Dockerfile.minimal` - Lightweight version for faster builds and less disk space
- `Dockerfile.alternative` - Fallback version with alternative approach for key verification

### 3. Enhanced Management Scripts
- `run-kali.bat` - Improved Windows batch script with multiple actions and options
- `run-kali-container.ps1` - Enhanced PowerShell script with advanced features
- `kali-quickstart.bat` - One-click solution for Windows users
- `run-kali.sh` - Added Linux companion script for cross-platform compatibility

### 4. XRDP Service Reliability
- Improved startup script to properly handle service failures
- Added auto-monitoring and auto-restart for failed services
- Better error handling and reporting

### 5. User Experience Improvements
- Added mount support for sharing directories with the host
- Custom port mapping for RDP connection
- Automated RDP client launching (on Windows)
- More informative output and helper messages

### 6. Documentation Updates
- Added `IMAGE_VARIANTS.md` with variant comparisons
- Updated README.md with troubleshooting information
- Added detailed usage information for all scripts

### 7. Docker Hub Publishing Support
- Added `build-push-dockerhub.sh` - Bash script for Linux/macOS users
- Added `build-push-dockerhub.ps1` - PowerShell script for Windows users
- Added `build-push-dockerhub.bat` - Simplified batch wrapper for Windows
- Added `push-large-images.bat` - Special script for handling large image uploads
- Added `push-minimal-image.bat` - Script focused on pushing just the minimal image
- Added `push-direct.bat` - Direct push script with logging for troubleshooting
- Enhanced retry logic for dealing with large Docker image uploads
- Documented Docker Hub publishing process in README.md
- Added configuration options for username, version tags, and image variants

### 8. Optimized Image Variants
- Added `Dockerfile.optimized` - Streamlined version of the full image with ~30-40% size reduction
- Added `Dockerfile.minimal.optimized` - Ultra-lean XFCE desktop with ~50-60% size reduction
- Added `Dockerfile.ultraslim` - Extremely minimal VNC-based image with ~70-80% size reduction
- Created `build-optimized-images.bat` - Script to easily build optimized variants
- Created `push-optimized-images.bat` - Script to push optimized variants to Docker Hub
- Created `check-image-sizes.bat` - Tool for comparing image sizes and selecting the best one
- Updated documentation with complete details about all image variants

## Usage Guide

### Quick Start (Windows)
```
kali-quickstart.bat
```

### Advanced Usage (PowerShell)
```
# Default build and run
.\run-kali-container.ps1

# Build and run minimal version
.\run-kali-container.ps1 -Minimal

# Use custom port
.\run-kali-container.ps1 -Port 3390

# Open shell in container
.\run-kali-container.ps1 -Action shell
```

### Linux Users
```
# First setup the script
chmod +x setup-linux.sh
./setup-linux.sh

# Then run using
./run-kali.sh
```
