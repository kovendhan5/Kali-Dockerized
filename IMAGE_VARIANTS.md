# Image Variants

This project provides three different Dockerfile variants for different use cases:

## 1. Full Image (`Dockerfile`)

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

## 2. Minimal Image (`Dockerfile.minimal`)

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

## 3. Alternative Image (`Dockerfile.alternative`)

A fallback version that:
- Uses alternative GPG key handling
- Different installation approach
- More tolerant of repository issues

This image is used automatically if the standard build fails.

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
