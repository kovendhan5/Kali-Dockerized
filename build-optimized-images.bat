@echo off
REM Build optimized Kali Docker images

echo === Building Optimized Kali Docker Images ===
echo.

SET DOCKER_HUB_USERNAME=kovendhan5
SET IMAGE_NAME=kali-dockerized

echo Choose which optimized Kali image to build:
echo 1. Standard optimized (with most tools)
echo 2. Minimal optimized (basic XFCE)
echo 3. Ultra-slim (minimal VNC-based)
echo 4. All versions
echo.

SET /p CHOICE="Enter your choice (1-4): "

IF "%CHOICE%"=="1" (
    echo.
    echo Building standard optimized image...
    docker build -t %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized -f Dockerfile.optimized .
    
    IF %ERRORLEVEL% NEQ 0 (
        echo Error building standard optimized image.
        pause
        exit /b 1
    ) else (
        echo Standard optimized image built successfully!
        echo Tag: %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized
    )
) ELSE IF "%CHOICE%"=="2" (
    echo.
    echo Building minimal optimized image...
    docker build -t %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized -f Dockerfile.minimal.optimized .
    
    IF %ERRORLEVEL% NEQ 0 (
        echo Error building minimal optimized image.
        pause
        exit /b 1
    ) else (
        echo Minimal optimized image built successfully!
        echo Tag: %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized
    )
) ELSE IF "%CHOICE%"=="3" (
    echo.
    echo Building ultra-slim image...
    docker build -t %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim -f Dockerfile.ultraslim .
    
    IF %ERRORLEVEL% NEQ 0 (
        echo Error building ultra-slim image.
        pause
        exit /b 1
    ) else (
        echo Ultra-slim image built successfully!
        echo Tag: %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim
    )
) ELSE IF "%CHOICE%"=="4" (
    echo.
    echo Building all optimized versions...
    
    echo Building standard optimized image...
    docker build -t %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized -f Dockerfile.optimized .
    
    echo Building minimal optimized image...
    docker build -t %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized -f Dockerfile.minimal.optimized .
    
    echo Building ultra-slim image...
    docker build -t %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim -f Dockerfile.ultraslim .
    
    echo All images built!
) ELSE (
    echo Invalid choice.
    pause
    exit /b 1
)

echo.
echo Would you like to run the newly built image?
SET /p RUN_IMAGE="Run image? (y/n): "

IF /i "%RUN_IMAGE%"=="y" (
    IF "%CHOICE%"=="1" (
        docker run -d -p 3389:3389 --name kali-optimized %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized
        echo Connect with RDP to localhost:3389
        echo Username: testuser
        echo Password: 1234
    ) ELSE IF "%CHOICE%"=="2" (
        docker run -d -p 3389:3389 --name kali-minimal-opt %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized
        echo Connect with RDP to localhost:3389
        echo Username: testuser
        echo Password: 1234
    ) ELSE IF "%CHOICE%"=="3" (
        docker run -d -p 5900:5900 --name kali-ultraslim %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim
        echo Connect with VNC to localhost:5900
        echo Password: 1234
    )
)

echo.
pause
