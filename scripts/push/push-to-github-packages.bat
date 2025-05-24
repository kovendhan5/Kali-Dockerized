@echo off
REM Push Docker images from Docker Hub to GitHub Packages
echo === Pushing Kali Docker Images to GitHub Packages ===
echo.

SET DOCKER_HUB_USERNAME=kovendhan5
SET GITHUB_USERNAME=kovendhan5
SET IMAGE_NAME=kali-dockerized
SET GITHUB_REPO=kali-dockerized

echo This script will help you push Docker images from Docker Hub to GitHub Packages.
echo.

REM Check if gh CLI is installed
where gh >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo GitHub CLI (gh) is not installed or not in PATH.
    echo You can still proceed with manual authentication.
    echo.
)

echo Logging in to GitHub Container Registry...
echo You may be prompted to authenticate.
echo.

REM Ask user for GitHub token if needed
set /p GITHUB_TOKEN=Enter your GitHub personal access token (or press Enter to use existing auth): 

if not "%GITHUB_TOKEN%"=="" (
    echo Logging in to GitHub Container Registry with provided token...
    echo %GITHUB_TOKEN% | docker login ghcr.io -u %GITHUB_USERNAME% --password-stdin
) else (
    echo Using existing GitHub authentication...
)

echo.
echo Step 1: Pulling images from Docker Hub...
echo.
echo Pulling Ultra-Slim image...
docker pull %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim
echo.
echo Pulling Minimal-Optimized image...
docker pull %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized

echo.
echo Step 2: Tagging images for GitHub Packages...
echo.
docker tag %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim ghcr.io/%GITHUB_USERNAME%/%IMAGE_NAME%:ultraslim
docker tag %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized ghcr.io/%GITHUB_USERNAME%/%IMAGE_NAME%:minimal-optimized

echo.
echo Step 3: Pushing images to GitHub Packages...
echo.
echo Pushing Ultra-Slim image to GitHub Packages...
docker push ghcr.io/%GITHUB_USERNAME%/%IMAGE_NAME%:ultraslim

echo.
echo Pushing Minimal-Optimized image to GitHub Packages...
docker push ghcr.io/%GITHUB_USERNAME%/%IMAGE_NAME%:minimal-optimized

echo.
if %ERRORLEVEL% equ 0 (
    echo Push successful! Your images are now available on GitHub Packages:
    echo https://github.com/%GITHUB_USERNAME%/%GITHUB_REPO/pkgs/container/%IMAGE_NAME%
) else (
    echo Push encountered some issues. You might need to check your GitHub authentication.
)

echo.
echo Remember to set the package visibility to public in GitHub if you want others to use it.
echo.

pause
