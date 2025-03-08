FROM kalilinux/kali-rolling:latest

# Update and install desktop environment and XRDP
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce && \
    apt install -y xrdp && \
    adduser xrdp ssl-cert

# Create a user and add to sudo group
RUN useradd -m testuser && \
    echo "testuser:1234" | chpasswd && \
    usermod -aG sudo testuser

# Expose port 3389
EXPOSE 3389

# Start services
CMD service xrdp start && \
    /bin/bash
