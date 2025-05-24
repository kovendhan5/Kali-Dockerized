@echo off
REM Script for pushing minimal-optimized image to Docker Hub
REM This focuses on the minimal-optimized image which is smaller than standard but has more features than ultraslim

echo === Pushing Minimal-Optimized Kali Image to Docker Hub ===
echo.

SET IMAGE=kovendhan5/kali-dockerized:minimal-optimized

echo Pushing %IMAGE%
echo This is our optimized minimal image with XFCE desktop.
echo.
echo Press any key to start the push process...
pause > nul

echo.
echo Starting push process...
docker push %IMAGE%

echo.
if %ERRORLEVEL% equ 0 (
    echo Push successful! The minimal-optimized image is now available on Docker Hub.
    echo https://hub.docker.com/r/kovendhan5/kali-dockerized
) else (
    echo Push encountered issues. You can try again later with:
    echo docker push %IMAGE%
)

echo.
pause
