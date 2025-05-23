# Image Variants

This project provides multiple Dockerfile variants for different use cases:

## Standard Images

### 1. Full Image (`Dockerfile`)

The default image includes:
- XFCE desktop environment
- Full set of common Kali penetration testing tools
- Web browsers and utilities
- Size: ~2.5GB+

Best for: Full penetration testing and security work

```bash
# Build and run the full image
./run-kali-container.ps1
```

### 2. Minimal Image (`Dockerfile.minimal`)

A lightweight variant with:
- Basic XFCE desktop
- Firefox and network utilities
- Minimal toolset
- Size: ~1GB

Best for: Development, learning, or when disk space is limited

```bash
# Build and run the minimal image
./run-kali-container.ps1 -Minimal
```

### 3. Alternative Image (`Dockerfile.alternative`)

A fallback version that:
- Uses alternative GPG key handling
- Different installation approach
- More tolerant of repository issues

This image is used automatically if the standard build fails.

## Optimized Images

These variants are specifically designed to be smaller for easier pushing to Docker Hub:

### 4. Optimized Full Image (`Dockerfile.optimized`)

- Contains most of the tools from the full image
- Aggressive cleanup to reduce size
- Single-layer installation for efficient storage
- Size: ~30-40% smaller than the full version

```bash
# Build the optimized image
build-optimized-images.bat
# Select option 1
```

### 5. Optimized Minimal Image (`Dockerfile.minimal.optimized`)

- Ultra-lean XFCE desktop with only essential components
- No Firefox to reduce size significantly
- Bare minimum packages required for a functional RDP desktop
- Size: ~50-60% smaller than the minimal version

```bash
# Build the optimized minimal image
build-optimized-images.bat
# Select option 2
```

### 6. Ultra-Slim Image (`Dockerfile.ultraslim`)

- Extremely minimal with Fluxbox window manager instead of XFCE
- Uses VNC instead of RDP (port 5900)
- Minimal system tools only
- Size: ~70-80% smaller than the full version

```bash
# Build the ultra-slim image
build-optimized-images.bat
# Select option 3
```

# Size Comparison

To compare the sizes of different image variants:

```bash
check-image-sizes.bat
```

This will show you which image is the smallest and best suited for pushing to Docker Hub.

# Quick Start Guide

For Windows users, the easiest way to get started is:

```
kali-quickstart.bat
```

This will:
1. Check if a container already exists
2. Start it or create a new one if needed
3. Launch Remote Desktop Connection automatically
4. Provide login credentials
