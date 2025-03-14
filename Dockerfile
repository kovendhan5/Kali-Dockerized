FROM kalilinux/kali-rolling:latest

# Install XFCE desktop environment and XRDP
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce xrdp dbus-x11 && \
    adduser xrdp ssl-cert

# Create a test user with sudo privileges
RUN useradd -m testuser && \
    echo "testuser:1234" | chpasswd && \
    usermod -aG sudo testuser

# Create persistent data directory
RUN mkdir -p /kali-data
VOLUME ["/kali-data"]

# Copy the XRDP startup script and make it executable
COPY start-xrdp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-xrdp.sh

# Expose RDP port
EXPOSE 3389

# Start XRDP service when container launches
ENTRYPOINT ["/usr/local/bin/start-xrdp.sh"]

# Default command (will be passed as arguments to the entrypoint)
CMD ["bash"]
