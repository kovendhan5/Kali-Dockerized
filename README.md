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

## Building the Docker Image

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

Example output:

```
Starting Remote Desktop Protocol server: xrdp-sesmanxrdp-sesman[23]: [INFO ] starting xrdp-sesman with pid 23

 xrdp.
┌──(root㉿49a9aad56d46)-[/]
└─# xrdp-sesman[23]: [INFO ] Socket 11: AF_INET6 connection received from ::1 port 33856

xrdp-sesman[23]: [INFO ] Terminal Server Users group is disabled, allowing authentication

xrdp-sesman[23]: [INFO ] ++ created session (access granted): username testuser, ip ::ffff:172.17.0.1:51780 - socket: 11

xrdp-sesman[23]: [INFO ] starting Xorg session...

xrdp-sesman[23]: [INFO ] Starting session: session_pid 37, display :10.0, width 1920, height 1080, bpp 24, client ip ::ffff:172.17.0.1:51780 - socket: 11, user name testuser

xrdp-sesman[37]: [INFO ] [session start] (display 10): calling auth_start_session from pid 37
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

## Troubleshooting

### RDP Connection Issues

If you can't connect via RDP:

- Ensure port 3389 is not blocked by a firewall
- Check that the XRDP service is running in the container
- Try restarting the container

### Black Screen After Connection

If you see a black screen after connecting:

- The XFCE session might not have started correctly
- Try restarting the container and reconnecting

### Performance Issues

For better performance:

- Allocate more resources to Docker
- Use a lower screen resolution in your RDP client settings

## Notes

- This container runs with root privileges by default
- For security in production environments, consider modifying the setup to run with reduced privileges
- The container does not persist data by default; use Docker volumes if you need to save your work
