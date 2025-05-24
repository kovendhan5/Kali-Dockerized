@echo off
REM Script for pushing large Docker images with optimized settings

echo === Push Large Docker Images to Docker Hub ===
echo.

REM Check Docker
where docker >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: Docker is not installed or not in PATH.
    goto :EOF
)

REM Check login status
docker info | findstr "Username" >nul
if %ERRORLEVEL% neq 0 (
    echo You need to login to Docker Hub first.
    docker login
    if %ERRORLEVEL% neq 0 (
        echo Login failed. Exiting.
        goto :EOF
    )
)

SET DOCKER_HUB_USERNAME=kovendhan5
SET IMAGE_NAME=kali-dockerized

echo.
echo Pushing images for %DOCKER_HUB_USERNAME%/%IMAGE_NAME%
echo.

echo =================================
echo PUSHING MAIN IMAGE - THIS MAY TAKE A WHILE
echo =================================
echo.
docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest --disable-content-trust
if %ERRORLEVEL% neq 0 (
    echo WARNING: Push of main image may have failed or been interrupted.
    echo Try running this command manually:
    echo docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest --disable-content-trust
    echo.
)

echo.
echo =================================
echo PUSHING MINIMAL IMAGE
echo =================================
echo.
docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal --disable-content-trust
if %ERRORLEVEL% neq 0 (
    echo WARNING: Push of minimal image may have failed or been interrupted.
    echo Try running this command manually:
    echo docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal --disable-content-trust
    echo.
)

echo.
echo If uploads were successful, your images are now available on Docker Hub:
echo https://hub.docker.com/r/%DOCKER_HUB_USERNAME%/%IMAGE_NAME%
echo.
echo If uploads were interrupted, you can try running this script again 
echo or use the Docker CLI commands shown above.
echo.

pause
