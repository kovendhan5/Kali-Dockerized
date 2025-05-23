# Data Persistence in Kali Docker

## Overview

This document explains how user data and customizations are preserved between container sessions in the Kali Docker setup.

## How Data Persistence Works

1. **Docker Volume**: 
   - A Docker volume named `kali-rdp_home` is created to store the `/home` directory
   - This ensures all user files, preferences, and customizations are preserved
   - The volume remains intact even when the container is stopped or restarted

2. **Container Restart Behavior**:
   - When using `run-kali.bat restart` or `kali-quickstart.bat` for an existing container:
     * The container is restarted with all data intact
     * No user files are lost
   - When recreating a container (optional choice during restart):
     * User is warned about potential data loss
     * Confirmation is required before deletion

## What Gets Preserved

- All files in the user's home directory
- Desktop files and shortcuts
- Application settings
- Browser bookmarks 
- Command history
- Installed tools (if installed in the home directory)
- Terminal customizations

## What Doesn't Get Preserved (if container is recreated)

- System-wide configurations outside /home
- Packages installed via apt (unless reinstalled)
- Services configured at the system level
- Files outside the /home directory

## Best Practices

1. Store important files in your home directory (`/home/kali` or `/home/testuser`)
2. For persistent system changes, consider creating a custom Dockerfile
3. Use the container restart option instead of recreating when possible
4. Create regular backups of important work

## Backups

To back up your user data from the Docker volume:

```bash
# Create a backup
docker run --rm -v kali-rdp_home:/source -v /path/on/host:/backup ubuntu tar -czvf /backup/kali-home-backup.tar.gz -C /source .

# Restore a backup
docker run --rm -v kali-rdp_home:/target -v /path/on/host:/backup ubuntu bash -c "rm -rf /target/* && tar -xzvf /backup/kali-home-backup.tar.gz -C /target"
```
