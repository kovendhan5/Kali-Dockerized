#!/bin/bash

# Configure XRDP 
echo "Configuring XRDP..."
cat > /etc/xrdp/xrdp.ini << EOF
[Globals]
ini_version=1
port=3389
tcp_nodelay=true
tcp_keepalive=true
security_layer=tls
crypt_level=high
allow_channels=true
max_bpp=24
fork=true
use_vsock=false

[Xorg]
name=Xorg
lib=libxup.so
username=ask
password=ask
ip=127.0.0.1
port=-1
code=20

[Xvnc]
name=Xvnc
lib=libvnc.so
username=ask
password=ask
ip=127.0.0.1
port=-1
xserverbpp=24
EOF

# Configure SESMAN
cat > /etc/xrdp/sesman.ini << EOF
[Globals]
ListenAddress=127.0.0.1
EnableUserWindowManager=true
UserWindowManager=startwm.sh
DefaultWindowManager=startwm.sh

[Security]
AllowRootLogin=true
MaxLoginRetry=4
TerminalServerUsers=tsusers
TerminalServerAdmins=tsadmins

[Sessions]
MaxSessions=50
KillDisconnected=false
IdleTimeLimit=0
DisconnectedTimeLimit=0

[Logging]
LogFile=xrdp-sesman.log
LogLevel=INFO
EnableSyslog=true
SyslogLevel=INFO

[X11rdp]
param=Xorg

[Xvnc]
param=-bs -ac -nolisten tcp -localhost -dpi 96
EOF

# Create startwm.sh for XFCE
cat > /etc/xrdp/startwm.sh << EOF
#!/bin/sh
if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG LANGUAGE
fi
startxfce4
EOF

chmod 755 /etc/xrdp/startwm.sh

# Make sure all required directories exist
mkdir -p /var/run/xrdp
mkdir -p /var/run/dbus

# Clean up any existing processes and files
echo "Cleaning up existing processes and PID files..."

# Kill any existing processes
pkill -9 xrdp 2>/dev/null || true
pkill -9 xrdp-sesman 2>/dev/null || true
pkill -9 dbus-daemon 2>/dev/null || true
sleep 2

# Remove all stale PID files
rm -f /run/dbus/pid 2>/dev/null || true
rm -f /var/run/dbus/pid 2>/dev/null || true
rm -f /var/run/xrdp/xrdp-sesman.pid 2>/dev/null || true
rm -f /var/run/xrdp/xrdp.pid 2>/dev/null || true

# Clean up socket files
rm -f /var/run/xrdp/xrdp_listen.sock 2>/dev/null || true
rm -f /var/run/xrdp/xrdp_api.sock 2>/dev/null || true

# Initialize D-Bus
echo "Starting D-Bus..."
mkdir -p /var/run/dbus
chown messagebus:messagebus /var/run/dbus
dbus-daemon --system --fork
sleep 1

# Start XRDP session manager
echo "Starting XRDP session manager..."
if /usr/sbin/xrdp-sesman; then
    echo "XRDP session manager started successfully"
    sleep 2
else
    echo "Failed to start XRDP session manager"
    exit 1
fi

# Start XRDP server
echo "Starting XRDP server..."
if /usr/sbin/xrdp; then
    echo "XRDP server started successfully"
    sleep 1
else
    echo "Failed to start XRDP server"
    exit 1
fi

# Verify XRDP processes are running
if ! pgrep xrdp-sesman > /dev/null; then
    echo "ERROR: XRDP session manager failed to start!"
    exit 1
fi

if ! pgrep xrdp > /dev/null; then
    echo "ERROR: XRDP server failed to start!"
    exit 1
fi

# Print connection information
echo ""
echo "=================================================="
echo "RDP server is running and ready for connections"
echo "Connect to this container using RDP on port 3389"
if id "kali" &>/dev/null; then
    echo "Username: kali"
else
    echo "Username: testuser"
fi
echo "Password: 1234"
echo ""
echo "Active processes:"
ps aux | grep -E "(xrdp|dbus)" | grep -v grep
echo "=================================================="
echo ""

# Function to monitor services
monitor_services() {
    while true; do
        if ! pgrep xrdp-sesman > /dev/null; then
            echo "WARNING: XRDP session manager stopped, restarting..."
            /usr/sbin/xrdp-sesman
        fi
        
        if ! pgrep xrdp > /dev/null; then
            echo "WARNING: XRDP server stopped, restarting..."
            /usr/sbin/xrdp
        fi
        
        sleep 30
    done
}

# Start monitoring in background
monitor_services &

# Keep the container running
tail -f /dev/null
