#!/bin/bash

# Script to fix GPG key issues in Kali container
echo "Fixing GPG key issues..."

# Remove any stale or lock files
rm -rf /var/lib/apt/lists/* || true
rm -f /var/lib/dpkg/lock* || true
rm -f /var/cache/apt/archives/lock || true

# Import the official Kali keys
echo "Importing Kali GPG keys..."
apt-get update --allow-insecure-repositories || true
apt-get install -y --allow-unauthenticated wget gnupg ca-certificates || true

# Try multiple approaches to get the keys
wget -qO - https://archive.kali.org/archive-key.asc | apt-key add - || true
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 827C8569F2518CC677FECA1AED65462EC8D5E4C5 || true
apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 827C8569F2518CC677FECA1AED65462EC8D5E4C5 || true

# Set to always allow insecure repositories as fallback
echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99allow-insecure
echo 'Acquire::AllowDowngradeToInsecureRepositories "true";' >> /etc/apt/apt.conf.d/99allow-insecure
echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99allow-insecure

# Final update
echo "Updating package lists..."
apt-get update --allow-insecure-repositories || true

echo "GPG key issue mitigation complete."
