@echo off
title Kali Docker Setup Verification
color 0A
echo ===================================
echo     KALI DOCKER SETUP VERIFICATION
echo ===================================
echo.

echo [1/6] Checking for required files...
echo.

set ERROR_FOUND=0

IF NOT EXIST Dockerfile (
  echo [ERROR] Missing main Dockerfile
  set ERROR_FOUND=1
) ELSE (
  echo [OK] Found main Dockerfile
)

IF NOT EXIST Dockerfile.minimal (
  echo [ERROR] Missing minimal Dockerfile
  set ERROR_FOUND=1
) ELSE (
  echo [OK] Found minimal Dockerfile
)

IF NOT EXIST start-xrdp.sh (
  echo [ERROR] Missing XRDP startup script
  set ERROR_FOUND=1
) ELSE (
  echo [OK] Found XRDP startup script
)

IF NOT EXIST fix-gpg-keys.sh (
  echo [ERROR] Missing GPG key fix script
  set ERROR_FOUND=1
) ELSE (
  echo [OK] Found GPG key fix script
)

IF NOT EXIST run-kali.bat (
  echo [ERROR] Missing run-kali.bat script
  set ERROR_FOUND=1
) ELSE (
  echo [OK] Found run-kali.bat script
)

echo.
echo [2/6] Checking for port conflicts...
echo.

netstat -an | findstr "0.0.0.0:3389" > nul
if %errorlevel% equ 0 (
  echo [WARNING] Port 3389 is already in use
  echo This may cause conflicts when running the container.
  echo Remember to use an alternative port with --port option.
) ELSE (
  echo [OK] Port 3389 is available
)

echo.
echo [3/6] Checking Docker installation...
echo.

docker --version > nul 2>&1
if %errorlevel% neq 0 (
  echo [ERROR] Docker is not installed or not in PATH
  set ERROR_FOUND=1
) ELSE (
  echo [OK] Docker is installed
)

docker ps > nul 2>&1
if %errorlevel% neq 0 (
  echo [WARNING] Docker daemon may not be running
  echo Start Docker Desktop before using these scripts.
) ELSE (
  echo [OK] Docker daemon is running
)

echo.
echo [4/6] Checking for existing containers...
echo.

docker ps -a | findstr kali-rdp > nul
if %errorlevel% equ 0 (
  echo [INFO] Existing kali-rdp container found
  
  docker ps | findstr kali-rdp > nul
  if %errorlevel% equ 0 (
    echo [INFO] Container is currently running
  ) ELSE (
    echo [INFO] Container exists but is not running
  )
) ELSE (
  echo [INFO] No existing kali-rdp container found
)

echo.
echo [5/6] Checking for existing images...
echo.

docker images | findstr kali > nul
if %errorlevel% equ 0 (
  echo [INFO] Existing kali image found
) ELSE (
  echo [INFO] No existing kali image found
  echo You'll need to build the image when starting for the first time.
)

echo.
echo [6/6] Providing recommended next steps...
echo.

if %ERROR_FOUND% equ 1 (
  echo [ACTION REQUIRED] Please fix the errors above before continuing.
) ELSE (
  echo [SUCCESS] Basic verification complete. No critical errors found.
  echo.
  echo Recommended next steps:
  echo.
  echo 1. For quick start Windows:
  echo    kali-quickstart.bat
  echo.
  echo 2. For more options:
  echo    run-kali.bat help
  echo.
  echo 3. For PowerShell users:
  echo    .\run-kali-container.ps1
  echo.
)

pause
