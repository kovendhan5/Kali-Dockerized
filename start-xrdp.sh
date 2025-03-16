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

# Fix the D-Bus issue - check for stale pid file
if [ -f "/run/dbus/pid" ]; then
    echo "Removing stale D-Bus pid file"
    rm -f /run/dbus/pid
fi

# Remove stale xrdp pid files
if [ -f "/var/run/xrdp/xrdp-sesman.pid" ]; then
    echo "Removing stale xrdp-sesman pid file"
    rm -f /var/run/xrdp/xrdp-sesman.pid
fi

if [ -f "/var/run/xrdp/xrdp.pid" ]; then
    echo "Removing stale xrdp pid file"
    rm -f /var/run/xrdp/xrdp.pid
fi

# Initialize D-Bus
echo "Starting D-Bus..."
mkdir -p /var/run/dbus
chown messagebus:messagebus /var/run/dbus
dbus-daemon --system

# Kill any existing xrdp processes
pkill -9 xrdp 2>/dev/null || true
pkill -9 xrdp-sesman 2>/dev/null || true
sleep 1

# Start XRDP session manager
echo "Starting XRDP components..."
/usr/sbin/xrdp-sesman --daemon
sleep 2

# Start XRDP server
/usr/sbin/xrdp --daemon
sleep 1

# Verify XRDP processes are running
if ! pgrep xrdp > /dev/null; then
    echo "ERROR: XRDP failed to start!"
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
tail -f /dev/null
