@echo off
REM Enhanced batch script to run Kali Docker container with fallback

echo Building Kali Linux Docker image...
echo Attempting build with primary Dockerfile...
docker build -t kali . --no-cache

if %errorlevel% neq 0 (
    echo Primary build failed! Trying alternative Dockerfile...
    if exist "Dockerfile.alternative" (
        docker build -t kali . -f Dockerfile.alternative --no-cache
        if %errorlevel% neq 0 (
            echo Both build attempts failed!
            echo This might be due to network issues or repository problems.
            echo Try again later or check your internet connection.
            pause
            exit /b 1
        )
        echo Alternative build succeeded!
    ) else (
        echo No alternative Dockerfile found!
        pause
        exit /b 1
    )
) else (
    echo Primary build succeeded!
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
