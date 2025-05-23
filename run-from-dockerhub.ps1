# Run Kali Docker from Docker Hub
# This script helps pull and run the Kali Docker image from Docker Hub

param(
    [Parameter(Mandatory=$false)]
    [string]$DockerHubUsername,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("latest", "minimal")]
    [string]$Tag = "latest",
    
    [Parameter(Mandatory=$false)]
    [int]$Port = 3389,
    
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "kali-rdp"
)

# Check if Docker is installed
try {
    $null = Get-Command docker -ErrorAction Stop
}
catch {
    Write-Host "Error: Docker is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

Write-Host "=== Kali Dockerized - Docker Hub Runner ===" -ForegroundColor Green
Write-Host

# If username not provided, ask for it
if ([string]::IsNullOrEmpty($DockerHubUsername)) {
    $DockerHubUsername = Read-Host -Prompt "Enter the Docker Hub username to pull from (leave blank for official image)"
    
    if ([string]::IsNullOrEmpty($DockerHubUsername)) {
        Write-Host "Using official Kali Docker image from Docker Hub"
        $imageName = "kalilinux/kali-rolling:latest"
    } else {
        $imageName = "${DockerHubUsername}/kali-dockerized:${Tag}"
    }
} else {
    $imageName = "${DockerHubUsername}/kali-dockerized:${Tag}"
}

# Check if container with the same name already exists
$containerExists = docker ps -a --format "{{.Names}}" | Select-String -Pattern "^${ContainerName}$"

if ($containerExists) {
    Write-Host "Container with name '${ContainerName}' already exists." -ForegroundColor Yellow
    $choice = Read-Host -Prompt "Do you want to (S)top and remove it, (R)estart it, or (C)ancel? [S/R/C]"
    
    switch ($choice.ToUpper()) {
        "S" {
            Write-Host "Stopping and removing existing container..." -ForegroundColor Yellow
            docker stop $ContainerName
            docker rm $ContainerName
        }
        "R" {
            Write-Host "Restarting existing container..." -ForegroundColor Yellow
            docker restart $ContainerName
            Write-Host "Container restarted. You can now connect via RDP to localhost:${Port}" -ForegroundColor Green
            exit 0
        }
        default {
            Write-Host "Operation cancelled." -ForegroundColor Red
            exit 0
        }
    }
}

# Pull the image
Write-Host "Pulling image: $imageName" -ForegroundColor Cyan
docker pull $imageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to pull the image. Please check your Docker Hub username and internet connection." -ForegroundColor Red
    exit 1
}

# Creating and starting the container
Write-Host "Creating and starting container..." -ForegroundColor Cyan
docker run -d --name $ContainerName -p "${Port}:3389" -v "${ContainerName}_home:/home" $imageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to create and start the container." -ForegroundColor Red
    exit 1
}

Write-Host "`nContainer started successfully!" -ForegroundColor Green
Write-Host "Container Name: $ContainerName" -ForegroundColor Green
Write-Host "RDP Port: $Port" -ForegroundColor Green
Write-Host "Image: $imageName" -ForegroundColor Green
Write-Host "`nYou can now connect via RDP to localhost:${Port}" -ForegroundColor Green
Write-Host "Default credentials:" -ForegroundColor Green
Write-Host "  Username: testuser (or kali)" -ForegroundColor Cyan
Write-Host "  Password: 1234" -ForegroundColor Cyan

# Ask if user wants to launch RDP client
$launchRDP = Read-Host -Prompt "`nDo you want to launch Remote Desktop Connection now? (y/n)"
if ($launchRDP.ToLower() -eq "y") {
    Start-Process "mstsc.exe" -ArgumentList "/v:localhost:${Port}"
}
