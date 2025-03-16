# Kali Linux in Docker with GUI

This repository contains a Dockerfile to build and run a Kali Linux container with a graphical user interface (GUI) accessible via Remote Desktop Protocol (RDP).

## Overview

This Docker setup provides:

- Kali Linux with XFCE desktop environment
- RDP access via port 3389
- A preconfigured user account for easy access

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

## Troubleshooting

### RDP Connection Issues

If you can't connect via RDP:

- Ensure port 3389 is not blocked by a firewall
- Check that the XRDP service is running in the container
- Verify you used the `-p 3389:3389` flag when starting the container
- Try restarting the container

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
