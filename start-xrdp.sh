#!/bin/bash

# Configure XRDP
sed -i 's/port=3389/port=3389/g' /etc/xrdp/xrdp.ini
sed -i 's/max_bpp=32/max_bpp=24/g' /etc/xrdp/xrdp.ini
sed -i 's/xserverbpp=24/xserverbpp=24/g' /etc/xrdp/xrdp.ini

# Make sure all required directories exist
mkdir -p /var/run/xrdp
mkdir -p /var/run/dbus

# Fix the D-Bus issue - check for stale pid file
if [ -f "/run/dbus/pid" ]; then
    echo "Removing stale D-Bus pid file"
    rm -f /run/dbus/pid
fi

# Initialize D-Bus
mkdir -p /var/run/dbus
chown messagebus:messagebus /var/run/dbus
dbus-daemon --system

# Check if xrdp-sesman is running
if pgrep xrdp-sesman > /dev/null; then
    echo "xrdp-sesman is already running."
else
    # Start the xrdp service
    service xrdp start
fi

# Print connection information
echo ""
echo "=================================================="
echo "RDP server is running and ready for connections"
echo "Connect to this container using RDP on port 3389"
echo "Username: testuser"
echo "Password: 1234"
echo "=================================================="
echo ""

# Keep the container running
exec "$@"
