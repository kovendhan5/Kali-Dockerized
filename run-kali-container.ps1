# Build the Docker image
Write-Host "Building Kali Linux Docker image..." -ForegroundColor Green
docker build -t kali .

# Run the Docker container
Write-Host "Starting Kali Linux container..." -ForegroundColor Green
docker run -it -p 3389:3389 --name kali-rdp kali

# Note: To stop the container later, you can use:
# docker stop kali-rdp
# docker rm kali-rdp
