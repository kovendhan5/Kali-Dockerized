@echo off
REM Script to check image sizes and select the best one for Docker Hub publishing

echo ===================================
echo    KALI DOCKER IMAGE SIZE CHECK
echo ===================================
echo.

SET DOCKER_HUB_USERNAME=kovendhan5
SET IMAGE_NAME=kali-dockerized

echo Checking for existing images...
echo.

set /a COUNT=0
set /a OPTIMIZED_EXISTS=0
set /a MINIMAL_OPTIMIZED_EXISTS=0
set /a ULTRASLIM_EXISTS=0

docker images %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized 2>nul | find "latest-optimized" >nul
if %ERRORLEVEL% equ 0 (
    set /a OPTIMIZED_EXISTS=1
    set /a COUNT+=1
)

docker images %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized 2>nul | find "minimal-optimized" >nul  
if %ERRORLEVEL% equ 0 (
    set /a MINIMAL_OPTIMIZED_EXISTS=1
    set /a COUNT+=1
)

docker images %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim 2>nul | find "ultraslim" >nul
if %ERRORLEVEL% equ 0 (
    set /a ULTRASLIM_EXISTS=1  
    set /a COUNT+=1
)

if %COUNT% equ 0 (
    echo No optimized images found.
    echo Please run build-optimized-images.bat first.
    pause
    exit /b 1
)

echo Found %COUNT% optimized image variants.
echo.
echo === IMAGE SIZE COMPARISON ===
echo.

if %OPTIMIZED_EXISTS% equ 1 (
    echo Standard Optimized:
    for /f "tokens=*" %%i in ('docker images %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized --format "{{.Size}}"') do echo   %%i
    echo.
)

if %MINIMAL_OPTIMIZED_EXISTS% equ 1 (
    echo Minimal Optimized:
    for /f "tokens=*" %%i in ('docker images %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized --format "{{.Size}}"') do echo   %%i
    echo.
)

if %ULTRASLIM_EXISTS% equ 1 (
    echo Ultra-slim:
    for /f "tokens=*" %%i in ('docker images %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim --format "{{.Size}}"') do echo   %%i
    echo.
)

echo.
echo Based on the image sizes above, which would you like to push to Docker Hub?
echo 1. Standard Optimized
echo 2. Minimal Optimized
echo 3. Ultra-slim
echo.

set /p PUSH_CHOICE="Enter choice (1-3): "

if "%PUSH_CHOICE%"=="1" (
    if %OPTIMIZED_EXISTS% equ 1 (
        echo.
        echo Pushing Standard Optimized image to Docker Hub...
        docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:latest-optimized --disable-content-trust
    ) else (
        echo Image does not exist. Please build it first with build-optimized-images.bat
    )
) else if "%PUSH_CHOICE%"=="2" (
    if %MINIMAL_OPTIMIZED_EXISTS% equ 1 (
        echo.
        echo Pushing Minimal Optimized image to Docker Hub...
        docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:minimal-optimized --disable-content-trust
    ) else (
        echo Image does not exist. Please build it first with build-optimized-images.bat
    )
) else if "%PUSH_CHOICE%"=="3" (
    if %ULTRASLIM_EXISTS% equ 1 (
        echo.
        echo Pushing Ultra-slim image to Docker Hub...
        docker push %DOCKER_HUB_USERNAME%/%IMAGE_NAME%:ultraslim --disable-content-trust
    ) else (
        echo Image does not exist. Please build it first with build-optimized-images.bat
    )
) else (
    echo Invalid choice.
)

echo.
echo Done!
echo.
pause
