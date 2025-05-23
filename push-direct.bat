@echo off
echo === Pushing Kali Docker Images to Docker Hub (Direct Method) ===
echo %date% %time% > push_log.txt

echo Checking Docker login status... >> push_log.txt
docker info | findstr "Username" >> push_log.txt

echo Pushing ultra-slim image... >> push_log.txt
docker push kovendhan5/kali-dockerized:ultraslim >> push_log.txt 2>&1
if %ERRORLEVEL% equ 0 (
    echo Ultra-slim image pushed successfully! >> push_log.txt
) else (
    echo Failed to push ultra-slim image. Error code: %ERRORLEVEL% >> push_log.txt
)

echo. >> push_log.txt
echo Pushing minimal-optimized image... >> push_log.txt
docker push kovendhan5/kali-dockerized:minimal-optimized >> push_log.txt 2>&1
if %ERRORLEVEL% equ 0 (
    echo Minimal-optimized image pushed successfully! >> push_log.txt
) else (
    echo Failed to push minimal-optimized image. Error code: %ERRORLEVEL% >> push_log.txt
)

echo. >> push_log.txt
echo Process completed at %date% %time% >> push_log.txt
echo See push_log.txt for details.

echo Images have been pushed to Docker Hub.
echo Check push_log.txt for details.
echo.
