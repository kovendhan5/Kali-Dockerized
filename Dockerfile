FROM kalilinux/kali-rolling:latest

# Fix GPG key issues and update package lists
RUN apt-get update --allow-insecure-repositories || \
    (echo "Initial update failed, trying alternative approach..." && \
     apt-get update --allow-releaseinfo-change --allow-insecure-repositories) && \
    apt-get install -y --allow-unauthenticated kali-archive-keyring && \
    apt-get update

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
