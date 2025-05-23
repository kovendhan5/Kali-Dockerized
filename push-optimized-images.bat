@echo off
REM Push optimized Kali images to Docker Hub

echo === Push Optimized Kali Docker Images to Docker Hub ===
echo.

SET DOCKER_HUB_USERNAME=kovendhan5
SET IMAGE_NAME=kali-dockerized

REM Check Docker login
docker info | findstr "Username" >nul
if %ERRORLEVEL% neq 0 (
    echo You need to login to Docker Hub first.
    docker login
    if %ERRORLEVEL% neq 0 (
        echo Login failed. Exiting.
        goto :EOF
    )
)

echo Choose which optimized Kali image to push:
echo 1. Standard optimized (latest-optimized)
echo 2. Minimal optimized (minimal-optimized)
echo 3. Ultra-slim (ultraslim)
echo 4. All optimized versions
echo.

SET /p CHOICE="Enter your choice (1-4): "

IF "%CHOICE%"=="1" (
    echo.
    echo Pushing standard optimized image...
    docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized --disable-content-trust
) ELSE IF "%CHOICE%"=="2" (
    echo.
    echo Pushing minimal optimized image...
    docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized --disable-content-trust
) ELSE IF "%CHOICE%"=="3" (
    echo.
    echo Pushing ultra-slim image...
    docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim --disable-content-trust
) ELSE IF "%CHOICE%"=="4" (
    echo.
    echo Pushing all optimized versions...
    
    echo Pushing standard optimized image...
    docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized --disable-content-trust
    
    echo Pushing minimal optimized image...
    docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized --disable-content-trust
    
    echo Pushing ultra-slim image...
    docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim --disable-content-trust
) ELSE (
    echo Invalid choice.
    pause
    exit /b 1
)

echo.
echo If uploads were successful, your optimized images are now available on Docker Hub:
echo https://hub.docker.com/r/%DOCKER_HUB_USERNAME%/%IMAGE_NAME%
echo.
echo If any uploads were interrupted, you can try running this script again.
echo.

pause
