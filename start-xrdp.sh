#!/bin/bash

# Check if xrdp-sesman is running
if pgrep xrdp-sesman > /dev/null; then
  echo "xrdp-sesman is already running."
else
  # Remove the PID file if it exists
  if [ -f /var/run/xrdp/xrdp-sesman.pid ]; then
    rm /var/run/xrdp/xrdp-sesman.pid
  fi
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
tail -f /dev/null
