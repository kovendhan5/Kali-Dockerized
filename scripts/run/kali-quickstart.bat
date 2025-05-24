@echo off
cd /d "%~dp0"
color 0A
title Kali Docker QuickStart
setlocal EnableDelayedExpansion

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
        
        echo.
        echo ============================================================
        echo Your existing container is running with all your saved data.
        echo Any files or customizations you made are still available.
        echo ============================================================
        echo.
    ) else (
        echo Starting container with your saved data and customizations...
        docker start kali-rdp
        
        if !errorlevel! neq 0 (
            echo Failed to start existing container. It might be corrupted.
            echo Would you like to recreate it?
            echo WARNING: Recreating the container will lose any saved files
            echo         or customizations made inside the container.
            set /p recreate="Recreate container? (y/n): "
            
            if "!recreate!"=="y" (
                echo Removing old container...
                docker rm kali-rdp
                goto CREATE_NEW
            ) else (
                echo Operation cancelled.
                pause
                exit /b 1
            )
        ) else (
            echo.
            echo ============================================================
            echo Container successfully restarted with your previous data.
            echo All customizations and files have been preserved.
            echo ============================================================
            echo.
        )
    )
) else (
    :CREATE_NEW
    echo No existing container found.
    echo Creating new persistent container...
    echo.
    echo NOTE: Any changes you make inside the container will be 
    echo       automatically saved for future sessions.
    echo.
    echo Choose container type:
    echo  1. Full Kali with all tools
    echo  2. Minimal Kali (faster, smaller)
    echo.
    set /p choice="Enter choice (1/2): "
    
    REM Check for port conflicts before running
    SET PORT=3389
    netstat -an | findstr "0.0.0.0:3389" > nul
    if !errorlevel! equ 0 (
        echo.
        echo WARNING: Port 3389 is already in use!
        echo This is common if Windows Remote Desktop is running.
        echo.
        echo Select another port to use:
        echo  1. Use port 3390 (recommended)
        echo  2. Use port 3391
        echo  3. Use port 3392
        echo  4. Cancel operation
        echo.
        set /p port_choice="Enter choice (1-4): "
        
        if "!port_choice!"=="1" (
            SET PORT=3390
        ) else if "!port_choice!"=="2" (
            SET PORT=3391
        ) else if "!port_choice!"=="3" (
            SET PORT=3392
        ) else (
            echo Operation cancelled.
            pause
            exit /b 1
        )
    )
    
    if "%choice%"=="2" (
        call run-kali.bat minimal --port !PORT!
    ) else (
        call run-kali.bat --port !PORT!
    )
)

echo.
echo Waiting for XRDP to start...
timeout /t 5 > nul

echo.
echo Determining RDP port...
FOR /F "tokens=*" %%i IN ('docker port kali-rdp 3389') DO SET CONTAINER_PORT=%%i
IF NOT DEFINED CONTAINER_PORT (
    SET RDP_PORT=3389
) ELSE (
    FOR /F "tokens=2 delims=:" %%p IN ("!CONTAINER_PORT!") DO SET RDP_PORT=%%p
)

echo Starting Remote Desktop Connection...
echo Connecting to localhost:!RDP_PORT!
start mstsc.exe /v:localhost:!RDP_PORT!

echo.
echo Remember login credentials:
echo  Username: kali or testuser
echo  Password: 1234
echo.
echo Press any key to exit...
pause > nul
