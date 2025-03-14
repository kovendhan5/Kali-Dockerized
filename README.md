# Kali Linux Desktop in Docker with RDP Access

This project provides a Dockerized Kali Linux environment with a full XFCE desktop accessible via Remote Desktop Protocol (RDP).

## Features

- Kali Linux with XFCE desktop environment
- Remote access via RDP (port 3389)
- Persistent storage through Docker volume
- Pre-configured test user with sudo privileges
- Automatic XRDP configuration and startup

## Prerequisites

- Docker installed on your host system
- Remote Desktop Client (e.g., Microsoft Remote Desktop)

## Quick Start

### Build the Docker Image

```bash
docker build -t kali-desktop .
```

### Run the Container

```bash
docker run -d --name kali-desktop -p 3389:3389 -v kali-data:/kali-data kali-desktop
```

For better performance on some systems, you can try host networking:

```bash
docker run -d --name kali-desktop --network host -v kali-data:/kali-data kali-desktop
```

### Connect to the Container

1. Open your Remote Desktop client
2. Connect to `localhost:3389` or your Docker host IP on port 3389
3. Login credentials:
   - Username: `testuser`
   - Password: `1234`

## Remote Desktop Connection Tips

### For Windows 11/10 Users

If you're experiencing connection issues with the Remote Desktop client:

1. In Remote Desktop Connection, click "Show Options"
2. Go to the "Experience" tab
3. Reduce the connection speed to "LAN (10 Mbps or higher)"
4. Uncheck all visual features except "Persistent bitmap caching"
5. In "Advanced" > "Settings", select "RDP" as the security protocol

## Persistent Storage

All data stored in the `/kali-data` directory inside the container will persist across container restarts and removals. This is managed through a Docker volume named `kali-data`.

## Container Management

### Stop the Container

```bash
docker stop kali-desktop
```

### Start an Existing Container

```bash
docker start kali-desktop
```

### Remove the Container

```bash
docker rm -f kali-desktop
```

### View Container Logs

```bash
docker logs kali-desktop
```

## Customization

### Change Default User Credentials

Edit the Dockerfile and modify the following lines:

```dockerfile
RUN useradd -m testuser && \
    echo "testuser:1234" | chpasswd && \
    usermod -aG sudo testuser
```

### Add Additional Software

Edit the Dockerfile to install additional packages. For example:

```dockerfile
RUN apt update && \
    apt install -y metasploit-framework nmap wireshark
```

## Troubleshooting

### XRDP Connection Issues

If you cannot connect:

1. Check container logs: `docker logs kali-desktop`
2. Verify that port 3389 is listening inside the container:
   ```bash
   docker exec kali-desktop netstat -tln | grep 3389
   ```
3. Test if the port is accessible from the host:
   ```bash
   telnet localhost 3389
   ```
4. Check if the port forwarding is correctly configured:
   ```bash
   docker port kali-desktop
   ```

### Container Crashes

If the container crashes or exits unexpectedly, try running it with added debug information:

```bash
docker run -it --name kali-desktop -p 3389:3389 kali-desktop bash
```

This will let you run the container and start the script manually to observe any error messages.

## Security Considerations

This container is designed for development and testing purposes. Note the following security considerations:

- Default credentials are simple and should be changed for production use
- RDP traffic is not end-to-end encrypted by default
- The container runs with a sudo-capable user

## License

This project is open-source and available under the MIT License.
