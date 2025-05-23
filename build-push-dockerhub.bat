@echo off
REM Build and Push Kali Docker Images to Docker Hub - Batch Wrapper

echo === Kali Dockerized - Build and Push to Docker Hub ===
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: PowerShell is not installed or not in PATH.
    echo This script requires PowerShell to run.
    goto :EOF
)

REM Ask for minimal build
set /p BUILD_MINIMAL="Also build minimal version? (y/n): "
set MINIMAL_FLAG=""

if /i "%BUILD_MINIMAL%"=="y" set MINIMAL_FLAG="-BUILD_MINIMAL $true"

REM Execute PowerShell script with elevated privileges
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "".\build-push-dockerhub.ps1"" %MINIMAL_FLAG%' -Verb RunAs}"

echo.
echo If the script completed successfully, your images should now be on Docker Hub.
echo.
