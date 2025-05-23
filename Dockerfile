FROM kalilinux/kali-rolling:latest

# Install XFCE desktop environment and XRDP
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        kali-desktop-xfce \
        xrdp \
        dbus-x11 \
        supervisor \
        sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    adduser xrdp ssl-cert

# Create a user (check if kali user exists, if not create testuser)
RUN if id "kali" &>/dev/null; then \
        echo "kali:1234" | chpasswd && \
        usermod -aG sudo kali; \
    else \
        useradd -m testuser && \
        echo "testuser:1234" | chpasswd && \
        usermod -aG sudo testuser; \
    fi

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
