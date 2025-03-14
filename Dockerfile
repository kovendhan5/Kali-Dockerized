FROM kalilinux/kali-rolling:latest

# Install XFCE desktop environment and XRDP
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    kali-desktop-xfce \
    xrdp \
    dbus-x11 \
    xorgxrdp \
    net-tools \
    iputils-ping \
    locales && \
    adduser xrdp ssl-cert

# Configure locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Create a test user with sudo privileges
RUN useradd -m testuser && \
    echo "testuser:1234" | chpasswd && \
    usermod -aG sudo testuser

# Configure XRDP for XFCE
RUN echo "xfce4-session" > /home/testuser/.xsession && \
    chmod +x /home/testuser/.xsession && \
    chown testuser:testuser /home/testuser/.xsession

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
