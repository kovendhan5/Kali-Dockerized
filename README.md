# Kali Linux in Docker with GUI

This repository contains a Dockerfile to build and run a Kali Linux container with a graphical user interface (GUI) accessible via Remote Desktop Protocol (RDP).

## Recent Fixes

**Version 3.0 Updates:**
- Fixed XRDP startup issues and PID file conflicts
- Improved service monitoring and auto-restart functionality
- Enhanced container lifecycle management
- Better error handling and logging
- Support for both `kali` and `testuser` accounts
- Added health checks and service monitoring
- **NEW: Data persistence across container restarts**
- **NEW: Optimized image variants for smaller size**
- **NEW: Docker Hub publishing with size-optimized images**
- **NEW: Ultra-slim VNC-based variant for minimal size**
- **NEW: GitHub Packages support for all image variants**

## Overview

This Docker setup provides:

- Kali Linux with XFCE desktop environment
- RDP access via port 3389
- A preconfigured user account for easy access
- Automatic service recovery and monitoring
- Enhanced stability and error handling
- **Persistent storage for user data and customizations**

## Docker Hub & GitHub Packages

### Available Images

Pre-built images are available on both Docker Hub and GitHub Packages:

#### Docker Hub

```bash
# Pull the standard image
docker pull kovendhan5/kali-dockerized:latest

# Pull the minimal image
docker pull kovendhan5/kali-dockerized:minimal

# Pull the minimal-optimized image (recommended)
docker pull kovendhan5/kali-dockerized:minimal-optimized

# Pull the ultra-slim image (smallest)
docker pull kovendhan5/kali-dockerized:ultraslim
```

#### GitHub Packages

```bash
# Pull the minimal-optimized image
docker pull ghcr.io/kovendhan5/kali-dockerized:minimal-optimized

# Pull the ultra-slim image
docker pull ghcr.io/kovendhan5/kali-dockerized:ultraslim
```

### Recommended Images

- **For Full Features**: Use `kovendhan5/kali-dockerized:latest`
- **For Balanced Setup**: Use `kovendhan5/kali-dockerized:minimal-optimized`
- **For Minimal Size**: Use `kovendhan5/kali-dockerized:ultraslim`

### Publishing Your Own Images

To publish your own customized images:

1. To Docker Hub:
   ```
   push-minimal-optimized.bat
   push-ultraslim.bat
   ```

2. To GitHub Packages:
   ```
   push-to-github-packages.bat
   ```

See [DOCKER_HUB_NOTES.md](DOCKER_HUB_NOTES.md) for detailed information about publishing.

## Optimized Image Variants

This project now includes optimized Dockerfile variants to create smaller images that are easier to upload and download:

### Image Variants

1. **Standard Optimized** (`Dockerfile.optimized`)
   - Full Kali experience with common pentesting tools
   - Single-layer installation for smaller overall size
   - Aggressive cleanup of unnecessary files
   - ~30-40% smaller than the regular image

2. **Minimal Optimized** (`Dockerfile.minimal.optimized`)
   - Basic XFCE desktop with only essential components
   - Stripped locales and documentation
   - Very small footprint while maintaining RDP functionality
   - ~50-60% smaller than the regular image

3. **Ultra-Slim** (`Dockerfile.ultraslim`)
   - Extremely minimal setup using Fluxbox and VNC instead of XFCE/RDP
   - Bare minimum packages installed
   - Accessible via VNC on port 5900
   - ~70-80% smaller than the regular image

### Building Optimized Images

Use the included script to build the optimized images:
```bash
build-optimized-images.bat
```

For more details on image variants, see [IMAGE_VARIANTS.md](IMAGE_VARIANTS.md).

## Data Persistence

All user data is automatically preserved between container restarts using Docker volumes:

- User files and customizations are stored in a Docker volume
- Container restarts maintain all your data and settings
- No need for manual backups between sessions

For more details, see [DATA_PERSISTENCE.md](DATA_PERSISTENCE.md).

## Prerequisites

- Docker installed on your host system
- RDP client (like Microsoft Remote Desktop)

## Using the Pre-built Image from GitHub Container Registry

This Docker image is also available as a pre-built package on GitHub Container Registry.

### Pulling the Image

```bash
# Pull the latest version
docker pull ghcr.io/kovendhan5/kali-dockerized:latest

# Or pull a specific version
docker pull ghcr.io/kovendhan5/kali-dockerized:1.0.0
```

### Running the Pre-built Image

```bash
docker run -it -p 3389:3389 --name kali-rdp ghcr.io/kovendhan5/kali-dockerized:latest
```

## Building the Docker Image Locally

To build the Kali Linux Docker image, run the following command in the repository directory:

```bash
docker build -t kali .
```

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
- The container does not persist data by default; use Docker volumes if you need to save your work
