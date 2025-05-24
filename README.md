# Kali Linux in Docker with GUI

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-kovendhan5%2Fkali--dockerized-blue?logo=docker)](https://hub.docker.com/r/kovendhan5/kali-dockerized)
[![GitHub Packages](https://img.shields.io/badge/GitHub%20Packages-ghcr.io-green?logo=github)](https://github.com/kovendhan5/kali-dockerized/pkgs/container/kali-dockerized)
[![Size](https://img.shields.io/badge/Size-471MB%20to%204.47GB-orange)](#image-sizes)

This repository contains optimized Dockerfiles to build and run Kali Linux containers with graphical user interfaces accessible via RDP or VNC.

## 📋 Table of Contents

- [🚀 Quick Start](#quick-start)
- [📦 Available Images](#available-images)
- [📊 Image Sizes](#image-sizes)
- [🔧 Building Locally](#building-locally)
- [🏃 Running Containers](#running-containers)
- [📁 Repository Structure](#repository-structure)
- [📖 Documentation](#documentation)
- [🔗 Links](#links)

## 🚀 Quick Start

Get started immediately with pre-built images:

```bash
# Smallest size (recommended for most users)
docker run -it -p 3389:3389 --name kali-minimal kovendhan5/kali-dockerized:minimal-optimized

# Ultra-minimal VNC version
docker run -it -p 5900:5900 --name kali-vnc kovendhan5/kali-dockerized:ultraslim

# Full featured version
docker run -it -p 3389:3389 --name kali-full kovendhan5/kali-dockerized:latest-optimized
```

**Windows users**: Use `scripts\run\kali-quickstart.bat` for one-click setup!

## Recent Updates

**Version 3.0 - May 2025:**
- ✅ **Optimized image variants** - Up to 75% size reduction
- ✅ **Docker Hub publishing** - All variants available
- ✅ **GitHub Packages** - Alternative registry support  
- ✅ **Data persistence** - Automatic volume management
- ✅ **Enhanced scripts** - Better automation and error handling
- ✅ **Organized structure** - Clean directory organization

## Overview

This Docker setup provides:

- Kali Linux with XFCE desktop environment
- RDP access via port 3389
- A preconfigured user account for easy access
- Automatic service recovery and monitoring
- Enhanced stability and error handling
- **Persistent storage for user data and customizations**

## 📦 Available Images

### 🐳 Docker Hub

```bash
# Recommended for most users (471MB)
docker pull kovendhan5/kali-dockerized:minimal-optimized

# Smallest possible size (539MB, VNC-based)
docker pull kovendhan5/kali-dockerized:ultraslim

# Full-featured optimized (4.47GB)
docker pull kovendhan5/kali-dockerized:latest-optimized

# Legacy minimal version (1.71GB)
docker pull kovendhan5/kali-dockerized:minimal
```

### 📦 GitHub Packages

```bash
# Pull from GitHub Container Registry
docker pull ghcr.io/kovendhan5/kali-dockerized:minimal-optimized
docker pull ghcr.io/kovendhan5/kali-dockerized:ultraslim
```

## 📊 Image Sizes

Comparison of all available image variants:

| Repository | Tag | Size | Description |
|------------|-----|------|-------------|
| 🟢 `kovendhan5/kali-dockerized` | `minimal-optimized` | **471MB** | **Recommended** - Best balance of features and size |
| 🔵 `kovendhan5/kali-dockerized` | `ultraslim` | **539MB** | Smallest - VNC-based minimal setup |
| 🟡 `kovendhan5/kali-dockerized` | `minimal` | **1.71GB** | Legacy minimal version |
| 🟠 `kovendhan5/kali-dockerized` | `latest-optimized` | **4.47GB** | Full-featured optimized |

### GitHub Packages
| Repository | Tag | Size |
|------------|-----|------|
| `ghcr.io/kovendhan5/kali-dockerized` | `minimal-optimized` | **471MB** |
| `ghcr.io/kovendhan5/kali-dockerized` | `ultraslim` | **539MB** |

**💡 Recommendation**: Use `minimal-optimized` for the best experience with minimal download time.

## 🔧 Building Locally

### Quick Build
```bash
# Build standard image
docker build -f dockerfiles/Dockerfile -t kali .

# Build optimized variants
scripts\build\build-optimized-images.bat
```

### Available Dockerfiles
- `dockerfiles/Dockerfile` - Standard full image
- `dockerfiles/Dockerfile.minimal.optimized` - **Recommended** optimized minimal
- `dockerfiles/Dockerfile.ultraslim` - Ultra-minimal VNC-based
- `dockerfiles/Dockerfile.optimized` - Optimized full-featured

## 🏃 Running Containers

### Quick Start Scripts
```bash
# Windows one-click start
scripts\run\kali-quickstart.bat

# Advanced PowerShell runner
scripts\run\run-kali-container.ps1

# Run from Docker Hub
scripts\run\run-from-dockerhub.ps1
```

### Manual Docker Commands
```bash
# RDP access (recommended)
docker run -it -p 3389:3389 --name kali kovendhan5/kali-dockerized:minimal-optimized

# VNC access (ultra-slim)
docker run -it -p 5900:5900 --name kali-vnc kovendhan5/kali-dockerized:ultraslim

# With data persistence
docker run -it -p 3389:3389 -v kali-data:/home/testuser --name kali kovendhan5/kali-dockerized:minimal-optimized
```

**Connection Details:**
- **RDP**: `localhost:3389` (Username: `testuser`, Password: `1234`)
- **VNC**: `localhost:5900` (Password: `kali`)

## 📁 Repository Structure

```
📦 kali-dockerized/
├── 📄 README.md                    # Main documentation
├── 📄 DIRECTORY_STRUCTURE.md       # This organization guide
├── 📁 dockerfiles/                 # All Dockerfile variants
│   ├── 📄 Dockerfile               # Standard full image
│   ├── 📄 Dockerfile.minimal       # Legacy minimal
│   ├── 📄 Dockerfile.minimal.optimized  # ⭐ Recommended
│   ├── 📄 Dockerfile.optimized     # Optimized full
│   └── 📄 Dockerfile.ultraslim     # VNC ultra-minimal
├── 📁 scripts/
│   ├── 📁 build/                   # Build automation
│   ├── 📁 push/                    # Registry publishing
│   ├── 📁 run/                     # Container execution
│   └── 📁 utils/                   # Maintenance tools
└── 📁 docs/                        # Documentation
    ├── 📄 CHANGELOG.md             # Version history
    ├── 📄 IMAGE_VARIANTS.md        # Detailed comparisons
    ├── 📄 DATA_PERSISTENCE.md      # Persistence guide
    └── 📄 DOCKER_HUB_NOTES.md      # Publishing guide
```

See [`DIRECTORY_STRUCTURE.md`](DIRECTORY_STRUCTURE.md) for detailed organization information.

Example build output:

```
[+] Building 495.0s (8/8) FINISHED                                                                                                                                  docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                                                                0.1s
 => => transferring dockerfile: 504B                                                                                                                                                0.0s
 => [internal] load metadata for docker.io/kalilinux/kali-rolling:latest                                                                                                            5.2s
 => [auth] kalilinux/kali-rolling:pull token for registry-1.docker.io                                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                                                                   0.0s
 => => transferring context: 2B                                                                                                                                                     0.0s
 => [1/3] FROM docker.io/kalilinux/kali-rolling:latest@sha256:d08bebbd0f69def3ab4eec63c01e9fa3e17b28cd634faec4ade6540a46ecfddc                                                     13.6s
 => => resolve docker.io/kalilinux/kali-rolling:latest@sha256:d08bebbd0f69def3ab4eec63c01e9fa3e17b28cd634faec4ade6540a46ecfddc                                                      0.0s
 => => sha256:70a02e78eadb74819f2804aade60ec9286eb658a7a9a889a2f20e0d552177cc7 52.87MB / 52.87MB                                                                                    7.1s
 => => sha256:d08bebbd0f69def3ab4eec63c01e9fa3e17b28cd634faec4ade6540a46ecfddc 1.19kB / 1.19kB                                                                                      0.0s
 => => sha256:9820ddd2c0bbd2a5e01258cd9a7214bc9dd5f44465a002830dd316298f24b7db 429B / 429B                                                                                          0.0s
 => => sha256:117a912df1aaa1f0fd20d85b814518e30c71cec5952fcbe15e4fe17c2291569a 2.87kB / 2.87kB                                                                                      0.0s
 => => extracting sha256:70a02e78eadb74819f2804aade60ec9286eb658a7a9a889a2f20e0d552177cc7                                                                                           6.0s
 => [2/3] RUN apt update &&     DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce &&     apt install -y xrdp &&     adduser xrdp ssl-cert                           442.8s
 => [3/3] RUN useradd -m testuser &&     echo "testuser:1234" | chpasswd &&     usermod -aG sudo testuser                                                                           0.8s
 => exporting to image                                                                                                                                                             32.2s
 => => exporting layers                                                                                                                                                            32.1s
 => => writing image sha256:144fa2597ff7162cb1a90c4f10ccf034738fd8aafb3208d6faf4f355375a495f                                                                                        0.0s
 => => naming to docker.io/library/kali                                                                                                                                             0.0s
```

Note: The build process may take a while (8+ minutes) as it needs to install the XFCE desktop environment and RDP server.

## Running the Container

Run the container with the following command to expose the RDP port:

```bash
docker run -it -p 3389:3389 --name kali kali
```

**Important:** Always use the `-p 3389:3389` flag when running the container to map the RDP port correctly. Without this port mapping, you won't be able to connect to the container using RDP.

The container uses a startup script (`start-xrdp.sh`) that automatically:

- Checks if the XRDP service is running
- Starts the service if it's not running
- Keeps the container running with `tail -f /dev/null`
- Provides a bash shell for interaction

Example output:

```
Starting Remote Desktop Protocol server: xrdp-sesmanxrdp-sesman[23]: [INFO ] starting xrdp-sesman with pid 23

 xrdp.
==================================================
RDP server is running and ready for connections
Connect to this container using RDP on port 3389
Username: testuser
Password: 1234
==================================================

┌──(root㉿49a9aad56d46)-[/]
└─#
```

## Connecting via RDP

1. Open your RDP client (such as Microsoft Remote Desktop)
2. Connect to `localhost:3389` or your host machine's IP address on port 3389
3. Use the following credentials:
   - Username: `testuser`
   - Password: `1234`

## Container Details

- Base Image: `kalilinux/kali-rolling:latest`
- Desktop Environment: XFCE
- Remote Access: XRDP on port 3389
- Default User:
  - Username: `testuser`
  - Password: `1234`
  - Has sudo privileges
- Startup Script: Automatically manages XRDP service

## Customization Options

### Changing the User Password

If you want to use a different password, modify the following line in the Dockerfile:

```dockerfile
echo "testuser:1234" | chpasswd
```

### Installing Additional Tools

You can install additional Kali tools by adding more `apt install` commands to the Dockerfile.

Example:

```dockerfile
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce && \
    apt install -y xrdp && \
    apt install -y kali-tools-top10 && \
    adduser xrdp ssl-cert
```

## Publishing to GitHub Container Registry

This project uses GitHub Actions to automatically build and publish the Docker image to GitHub Container Registry.

### Automated Publishing

The Docker image is automatically built and published to GitHub Container Registry when:

- Changes are pushed to the main/master branch
- A new tag starting with 'v' is created (e.g., v1.0.0)
- The workflow is manually triggered from the Actions tab

The GitHub Actions workflow:

1. Builds the Docker image
2. Tags it with appropriate version tags
3. Pushes it to GitHub Container Registry

### Manual Setup Requirements

To enable automated publishing, you need to:

1. **Fork or push this repository to GitHub**
2. **Enable GitHub Actions**: Go to your repository → Actions tab → Enable workflows
3. **Set repository permissions**: Go to repository → Settings → Actions → General → Workflow permissions → Set to "Read and write permissions"

The workflow will use the GitHub-provided `GITHUB_TOKEN`, so no manual token creation is required.

### Available Image Tags

The published image will be tagged with:

- `latest` - the most recent build from the main branch
- `v1.0.0` - specific version tags (when a tag is pushed)
- `1.0` - major.minor tags (when a tag is pushed)
- `sha-<commit>` - specific commit references

## Publishing to Docker Hub

You can publish this image to your Docker Hub account using the provided scripts:

### Windows Users

Run the batch script:

```cmd
build-push-dockerhub.bat
```

Or use PowerShell directly:

```powershell
.\build-push-dockerhub.ps1
```

### Linux/macOS Users

Run the shell script:

```bash
chmod +x build-push-dockerhub.sh
./build-push-dockerhub.sh
```

### Configuration

Before running the scripts, you'll need to:

1. Have a Docker Hub account
2. Log in to Docker Hub using `docker login`
3. Either:
   - Set your Docker Hub username in the script file
   - Or provide it when prompted

### Publishing Options

The scripts allow you to:
- Publish both the full and minimal variants of the image
- Choose a specific version tag
- Push to your own Docker Hub namespace

After publishing, you can pull your image using:

```bash
docker pull your-username/kali-dockerized:latest
```

## Troubleshooting

### GPG Key Issues

If you encounter GPG key verification errors during the Docker build process, the scripts have been updated to handle this automatically. They will:

1. Try different methods to import the Kali Linux GPG keys
2. Use `--allow-insecure-repositories` and `--allow-unauthenticated` as fallbacks
3. Try an alternative Dockerfile if the main one fails

If you still encounter issues, you can manually fix them by running:

```bash
docker run --rm -it kalilinux/kali-rolling:latest bash
```

Then within that container:

```bash
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 827C8569F2518CC677FECA1AED65462EC8D5E4C5
apt update
```

### XRDP Connection Issues

If you have trouble connecting to the container via RDP:

1. Ensure port 3389 is not being used by another service on your host
2. Try restarting the container: `docker restart kali-rdp`
3. Check the logs: `docker logs kali-rdp`

### Container Not Accessible via RDP

If you've started the container but cannot connect via RDP:

1. **Issue**: The container may be running but not properly exposing port 3389, or the container might exit prematurely.

2. **Solution**:

   - Always use the `-p 3389:3389` flag when running the container:
     ```bash
     docker run -it -p 3389:3389 --name kali-rdp kali
     ```
   - Use the included PowerShell script which handles this properly:
     ```powershell
     .\run-kali-container.ps1
     ```
   - Ensure the `start-xrdp.sh` script contains the `tail -f /dev/null` command to keep the container running

3. **Verification**:
   - Check if the container is running and exposing ports:
     ```bash
     docker ps
     ```
   - You should see an entry with `0.0.0.0:3389->3389/tcp` in the PORTS column

### Black Screen After Connection

If you see a black screen after connecting:

- The XFCE session might not have started correctly
- Try restarting the container and reconnecting

### Performance Issues

For better performance:

- This container runs with root privileges by default
- For security in production environments, consider modifying the setup to run with reduced privileges
- Use Docker volumes for data persistence

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [`docs/IMAGE_VARIANTS.md`](docs/IMAGE_VARIANTS.md) | Detailed comparison of all image variants |
| [`docs/DATA_PERSISTENCE.md`](docs/DATA_PERSISTENCE.md) | Guide to data persistence and volumes |
| [`docs/DOCKER_HUB_NOTES.md`](docs/DOCKER_HUB_NOTES.md) | Publishing and registry information |
| [`docs/CHANGELOG.md`](docs/CHANGELOG.md) | Version history and updates |
| [`DIRECTORY_STRUCTURE.md`](DIRECTORY_STRUCTURE.md) | Repository organization guide |

## 🔗 Links

- **🐳 Docker Hub**: [kovendhan5/kali-dockerized](https://hub.docker.com/r/kovendhan5/kali-dockerized)
- **📦 GitHub Packages**: [ghcr.io/kovendhan5/kali-dockerized](https://github.com/kovendhan5/kali-dockerized/pkgs/container/kali-dockerized)
- **📋 Issues**: [Report issues](https://github.com/kovendhan5/kali-dockerized/issues)
- **🤝 Contributing**: [Contribution guidelines](https://github.com/kovendhan5/kali-dockerized/blob/main/CONTRIBUTING.md)

## 📄 License

This project is open source. See the repository for license details.

---

⭐ **Star this repository** if you find it useful!

**💡 Need help?** Check the [documentation](docs/) or [open an issue](https://github.com/kovendhan5/kali-dockerized/issues).
