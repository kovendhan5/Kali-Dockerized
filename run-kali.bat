@echo off
REM Simple batch script to run Kali Docker container

echo === Kali Docker Container Manager ===
echo.
echo Step 1: Building Kali Linux Docker image...
echo This may take a while depending on your internet connection.
echo.
echo Building image with GPG key fix...
docker build -t kali . --no-cache

if %errorlevel% neq 0 (
    echo.
    echo Build failed! Trying alternative approach...
    echo.
    echo Attempting to build with alternative Dockerfile...
    
    if exist Dockerfile.alternative (
        docker build -t kali -f Dockerfile.alternative . --no-cache
        
        if %errorlevel% neq 0 (
            echo.
            echo All build attempts failed!
            echo Please check your internet connection and try again.
            pause
            exit /b 1
        ) else (
            echo.
            echo Build successful with alternative Dockerfile!
        )
    ) else (
        echo.
        echo Failed to build Docker image and no alternative Dockerfile found!
        pause
        exit /b 1
    )
) else (
    echo.
    echo Build completed successfully!
)

echo Stopping any existing container...
docker stop kali-rdp >nul 2>&1
docker rm kali-rdp >nul 2>&1

echo Starting Kali Linux container...
echo Container will be available on RDP port 3389
echo Default credentials: kali/testuser : 1234

docker run -d -p 3389:3389 --name kali-rdp kali

if %errorlevel% eq 0 (
    echo Container started successfully!
    echo Waiting for services to start...
    timeout /t 5 /nobreak >nul
    echo Container logs:
    docker logs kali-rdp
    echo.
    echo Connect to localhost:3389 using RDP client
) else (
    echo Failed to start container!
    pause
    exit /b 1
)

pause
