@echo off
REM Script for pushing just the minimal Kali Docker image

echo === Push Minimal Kali Docker Image to Docker Hub ===
echo.

SET DOCKER_HUB_USERNAME=kovendhan5
SET IMAGE_NAME=kali-dockerized

echo Pushing minimal image only: %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal
echo.
echo This may take some time depending on your internet connection...
echo.

docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal --disable-content-trust

if %ERRORLEVEL% neq 0 (
    echo WARNING: Push may have failed or been interrupted.
    echo.
    echo You can try again later with this command:
    echo docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal --disable-content-trust
) else (
    echo.
    echo Success! Your minimal image is now available at:
    echo https://hub.docker.com/r/%DOCKER_HUB_USERNAME%/%IMAGE_NAME%
    echo.
    echo You can pull it with:
    echo docker pull %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal
)

echo.
pause
