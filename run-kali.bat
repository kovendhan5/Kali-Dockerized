@echo off
REM Enhanced Kali Docker Container Manager
SETLOCAL EnableDelayedExpansion

REM Parse command line arguments
SET ACTION=run
SET IMAGE_NAME=kali
SET CONTAINER_NAME=kali-rdp
SET PORT=3389
SET MINIMAL=0

IF "%1"=="" GOTO SHOW_OPTIONS
IF "%1"=="help" GOTO SHOW_HELP

REM Process parameters
:PROCESS_ARGS
IF "%1"=="" GOTO AFTER_ARGS
IF /I "%1"=="build" SET ACTION=build
IF /I "%1"=="run" SET ACTION=run
IF /I "%1"=="stop" SET ACTION=stop
IF /I "%1"=="restart" SET ACTION=restart
IF /I "%1"=="shell" SET ACTION=shell
IF /I "%1"=="logs" SET ACTION=logs
IF /I "%1"=="minimal" SET MINIMAL=1
IF /I "%1"=="--port" SET PORT=%2 & SHIFT
IF /I "%1"=="--name" SET CONTAINER_NAME=%2 & SHIFT
SHIFT
GOTO PROCESS_ARGS
:AFTER_ARGS

:SHOW_OPTIONS
echo === Kali Docker Container Manager ===
echo.
echo Current Settings:
echo   Action:        %ACTION%
echo   Container:     %CONTAINER_NAME%
echo   Port:          %PORT%
echo   Minimal Mode:  %MINIMAL%
echo.
echo Type "run-kali.bat help" for available commands and options.
echo.

REM Execute the selected action
GOTO ACTION_%ACTION%

:SHOW_HELP
echo === Kali Docker Container Manager - Help ===
echo.
echo Usage: run-kali.bat [action] [options]
echo.
echo Available Actions:
echo   build    - Build the Docker image only
echo   run      - Build (if needed) and run the container (default)
echo   stop     - Stop the running container
echo   restart  - Restart the container
echo   shell    - Open a shell into the running container
echo   logs     - Show container logs
echo   help     - Show this help
echo.
echo Options:
echo   minimal     - Use minimal image (faster, but fewer tools)
echo   --port N    - Map RDP to port N (default: 3389)
echo   --name NAME - Use custom container name
echo.
echo Examples:
echo   run-kali.bat               - Build and run with default settings
echo   run-kali.bat minimal       - Build and run minimal version
echo   run-kali.bat --port 3390   - Use alternate port
echo   run-kali.bat stop          - Stop the container
echo   run-kali.bat shell         - Open shell in running container
echo.
GOTO END

:ACTION_build
echo Step 1: Building Kali Linux Docker image...
echo This may take a while depending on your internet connection.
echo.
IF "%MINIMAL%"=="1" (
    echo Building minimal image with GPG key fix...
    docker build -t %IMAGE_NAME% -f Dockerfile.minimal . --no-cache
) ELSE (
    echo Building full image with GPG key fix...
    docker build -t %IMAGE_NAME% . --no-cache
)

if %errorlevel% neq 0 (
    echo.
    echo Build failed! Trying alternative approach...
    echo.
    echo Attempting to build with alternative Dockerfile...
    
    if exist Dockerfile.alternative (
        docker build -t %IMAGE_NAME% -f Dockerfile.alternative . --no-cache
        
        if %errorlevel% neq 0 (
            echo.
            echo All build attempts failed!
            echo Please check your internet connection and try again.
            pause
            exit /b 1
        ) else (
            echo.
            echo Build successful with alternative Dockerfile!
        )
    ) else (
        echo.
        echo Failed to build Docker image and no alternative Dockerfile found!
        pause
        exit /b 1
    )
) else (
    echo.
    echo Build completed successfully!
)
GOTO END

:ACTION_run
echo Checking if image exists...
docker image inspect %IMAGE_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    GOTO ACTION_build
)

echo Stopping any existing container...
docker stop %CONTAINER_NAME% >nul 2>&1
docker rm %CONTAINER_NAME% >nul 2>&1

REM Check for port conflicts
netstat -an | findstr "0.0.0.0:%PORT%" > nul
if %errorlevel% equ 0 (
    echo.
    echo ERROR: Port %PORT% is already in use!
    echo This may be due to:
    echo  - Windows Remote Desktop service using port 3389
    echo  - Another Docker container mapping to this port
    echo  - Other services running on this port
    echo.
    echo Please try:
    echo  1. Using a different port (run-kali.bat --port 3390)
    echo  2. Stopping services that use port %PORT%
    echo.
    pause
    exit /b 1
)

echo Starting Kali Linux container...
echo Container will be available on RDP port %PORT%
echo Default credentials: kali/testuser : 1234
echo.

docker run -d -p %PORT%:3389 --name %CONTAINER_NAME% %IMAGE_NAME%

if %errorlevel% eq 0 (
    echo Container started successfully!
    echo Waiting for services to start...
    timeout /t 5 /nobreak >nul
    echo Container logs:
    docker logs %CONTAINER_NAME%
    echo.
    echo Connect to localhost:%PORT% using RDP client
) else (
    echo.
    echo Failed to start container!
    echo Error details:
    docker logs %CONTAINER_NAME% 2>nul
    pause
    exit /b 1
)
GOTO END

:ACTION_stop
echo Stopping Kali container %CONTAINER_NAME%...
docker stop %CONTAINER_NAME%
if %errorlevel% eq 0 (
    echo Container stopped successfully!
) else (
    echo No container named %CONTAINER_NAME% is running!
)
GOTO END

:ACTION_restart
echo Restarting Kali container %CONTAINER_NAME%...
docker restart %CONTAINER_NAME%
if %errorlevel% eq 0 (
    echo Container restarted successfully!
    timeout /t 5 /nobreak >nul
    docker logs --tail 10 %CONTAINER_NAME%
) else (
    echo No container named %CONTAINER_NAME% exists!
)
GOTO END

:ACTION_shell
echo Opening shell in Kali container %CONTAINER_NAME%...
docker exec -it %CONTAINER_NAME% bash
GOTO END

:ACTION_logs
echo Showing logs for Kali container %CONTAINER_NAME%...
docker logs -f %CONTAINER_NAME%
GOTO END

:END
echo.
pause
