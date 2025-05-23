@echo off
cd /d "%~dp0"
color 0A
title Kali Docker QuickStart

echo ===================================
echo  KALI LINUX DOCKER - QUICK START
echo ===================================
echo.
echo This script will:
echo  1. Start the Kali container
echo  2. Open Remote Desktop connection
echo.

REM Check if container exists
docker ps -a | findstr kali-rdp > nul
if %errorlevel% equ 0 (
    echo Found existing Kali container...
    
    REM Check if container is running
    docker ps | findstr kali-rdp > nul
    if %errorlevel% equ 0 (
        echo Container is already running
    ) else (
        echo Starting container...
        docker start kali-rdp
    )
) else (
    echo No existing container found.
    echo Creating new container...
    echo.
    echo Choose container type:
    echo  1. Full Kali with all tools
    echo  2. Minimal Kali (faster, smaller)
    echo.
    set /p choice="Enter choice (1/2): "
    
    if "%choice%"=="2" (
        call run-kali.bat minimal
    ) else (
        call run-kali.bat
    )
)

echo.
echo Waiting for XRDP to start...
timeout /t 5 > nul

echo.
echo Starting Remote Desktop Connection...
start mstsc.exe /v:localhost:3389

echo.
echo Remember login credentials:
echo  Username: kali or testuser
echo  Password: 1234
echo.
echo Press any key to exit...
pause > nul
