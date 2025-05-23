FROM kalilinux/kali-rolling:latest

# Fix GPG key issues using dedicated script
COPY fix-gpg-keys.sh /tmp/
RUN chmod +x /tmp/fix-gpg-keys.sh && /tmp/fix-gpg-keys.sh

# Install XFCE desktop environment and XRDP
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        kali-desktop-xfce \
        xrdp \
        dbus-x11 \
        supervisor \
        sudo \
        wget \
        curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    adduser xrdp ssl-cert

# Install common Kali tools (minimal set)
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
        nmap \
        metasploit-framework \
        burpsuite \
        wireshark \
        hydra \
        nikto \
        sqlmap \
        dirb \
        net-tools \
        iputils-ping \
        firefox-esr && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user for RDP access
RUN useradd -m testuser && \
    echo "testuser:1234" | chpasswd && \
    usermod -aG sudo testuser

# Copy the XRDP startup script and make it executable
COPY start-xrdp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-xrdp.sh

# Configure system for better RDP performance
RUN echo "session optional pam_systemd.so" >> /etc/pam.d/xrdp-sesman && \
    mkdir -p /var/run/dbus && \
    mkdir -p /var/run/xrdp && \
    chown messagebus:messagebus /var/run/dbus

# Expose RDP port
EXPOSE 3389

# Start XRDP service when container launches
ENTRYPOINT ["/usr/local/bin/start-xrdp.sh"]

# Default command (will be passed as arguments to the entrypoint)
CMD ["bash"]
