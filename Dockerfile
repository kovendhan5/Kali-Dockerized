FROM kalilinux/kali-rolling:latest

# Install XFCE desktop environment and XRDP
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce && \
    apt install -y xrdp && \
    adduser xrdp ssl-cert

# Create a test user with sudo privileges
RUN useradd -m testuser && \
    echo "testuser:1234" | chpasswd && \
    usermod -aG sudo testuser

# Copy the XRDP startup script and make it executable
COPY start-xrdp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-xrdp.sh

# Expose RDP port
EXPOSE 3389

# Start XRDP service when container launches
ENTRYPOINT ["/usr/local/bin/start-xrdp.sh"]




CMD ["bash"]# Default command (will be passed as arguments to the entrypoint)# The following line is not needed since we use ENTRYPOINT
# CMD ["bash"]
