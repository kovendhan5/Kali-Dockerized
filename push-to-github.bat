@echo off
REM Wrapper for PowerShell script to push Docker images to GitHub Packages

echo === Pushing Kali Docker Images to GitHub Packages ===
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File .\push-to-github-packages.ps1

echo.
pause
