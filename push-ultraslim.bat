@echo off
REM Simplified script for pushing ultra-slim image to Docker Hub
REM This focuses only on the ultra-slim image which is the smallest and most likely to succeed

echo === Pushing Ultra-Slim Kali Image to Docker Hub ===
echo.

SET IMAGE=kovendhan5/kali-dockerized:ultraslim

echo Pushing %IMAGE%
echo This is our smallest image and should upload successfully.
echo.
echo Press any key to start the push process...
pause > nul

echo.
echo Starting push process...
docker push %IMAGE%

echo.
if %ERRORLEVEL% equ 0 (
    echo Push successful! The ultra-slim image is now available on Docker Hub.
    echo https://hub.docker.com/r/kovendhan5/kali-dockerized
) else (
    echo Push encountered issues. You can try again later with:
    echo docker push %IMAGE%
)

echo.
pause
