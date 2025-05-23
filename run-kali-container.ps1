# Enhanced Kali Linux Docker Container Manager
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("build", "run", "stop", "restart", "logs", "clean", "shell")]
    [string]$Action = "run",
    
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "kali-rdp",
    
    [Parameter(Mandatory=$false)]
    [int]$Port = 3389,
    
    [Parameter(Mandatory=$false)]
    [switch]$Minimal
)

# Check if Docker is installed
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker not found! Please install Docker before running this script." -ForegroundColor Red
    exit 1
}

function Show-Usage {
    Write-Host "Usage: .\run-kali-container.ps1 [-Action <action>] [-ContainerName <name>] [-Port <port>] [-Minimal]" -ForegroundColor Yellow
    Write-Host "Actions:" -ForegroundColor Yellow
    Write-Host "  build    - Build the Docker image" -ForegroundColor Cyan
    Write-Host "  run      - Build and run the container (default)" -ForegroundColor Cyan
    Write-Host "  stop     - Stop the running container" -ForegroundColor Cyan
    Write-Host "  restart  - Restart the container" -ForegroundColor Cyan
    Write-Host "  shell    - Open a shell in the running container" -ForegroundColor Cyan
    Write-Host "  logs     - Show container logs" -ForegroundColor Cyan
    Write-Host "  clean    - Stop and remove container and image" -ForegroundColor Cyan
    Write-Host "Parameters:" -ForegroundColor Yellow
    Write-Host "  -ContainerName <name>  - Custom container name (default: kali-rdp)" -ForegroundColor Cyan
    Write-Host "  -Port <port>           - Map RDP to custom port (default: 3389)" -ForegroundColor Cyan
    Write-Host "  -Minimal               - Use minimal version (faster, fewer tools)" -ForegroundColor Cyan
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\run-kali-container.ps1                     - Default build and run" -ForegroundColor DarkCyan
    Write-Host "  .\run-kali-container.ps1 -Minimal           - Build minimal version" -ForegroundColor DarkCyan
    Write-Host "  .\run-kali-container.ps1 -Port 3390         - Use custom port" -ForegroundColor DarkCyan
    Write-Host "  .\run-kali-container.ps1 -Action shell      - Open shell in container" -ForegroundColor DarkCyan
}

function Build-Image {
    Write-Host "Building Kali Linux Docker image..." -ForegroundColor Green
    
    $dockerfile = if ($Minimal) { "Dockerfile.minimal" } else { "Dockerfile" }
    Write-Host "Using dockerfile: $dockerfile" -ForegroundColor Cyan
    
    docker build -t kali -f $dockerfile . --no-cache
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Image built successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to build with primary dockerfile. Trying alternative..." -ForegroundColor Yellow
        
        if (Test-Path "Dockerfile.alternative") {
            docker build -t kali -f Dockerfile.alternative . --no-cache
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Image built successfully with alternative Dockerfile!" -ForegroundColor Green
            } else {
                Write-Host "Failed to build image with alternative Dockerfile!" -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "Failed to build image and no alternative Dockerfile found!" -ForegroundColor Red
            exit 1
        }
    }
}

function Start-Container {
    # Check if container already exists
    $existingContainer = docker ps -a --filter "name=$ContainerName" --format "{{.Names}}"
    
    if ($existingContainer) {
        Write-Host "Container $ContainerName already exists. Stopping and removing..." -ForegroundColor Yellow
        docker stop $ContainerName 2>$null
        docker rm $ContainerName 2>$null
    }
    
    Write-Host "Starting Kali Linux container..." -ForegroundColor Green
    Write-Host "Container will be available on RDP port $Port" -ForegroundColor Cyan
    Write-Host "Default credentials: kali/testuser : 1234" -ForegroundColor Cyan
    
    # Check if we want to mount the current directory
    $volumeMount = ""
    $volumePrompt = Read-Host "Do you want to mount the current directory into the container? (y/n)"
    if ($volumePrompt -eq "y" -or $volumePrompt -eq "Y") {
        $currentDir = (Get-Location).Path
        $volumeMount = "-v ${currentDir}:/shared"
        Write-Host "Mounting $currentDir to /shared in the container" -ForegroundColor Cyan
    }
    
    Invoke-Expression "docker run -d -p ${Port}:3389 $volumeMount --name $ContainerName kali"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Container started successfully!" -ForegroundColor Green
        Start-Sleep 5
        docker logs $ContainerName
        
        Write-Host "`nAccess via RDP:" -ForegroundColor Green
        Write-Host "  1. Open Remote Desktop Connection" -ForegroundColor Cyan
        Write-Host "  2. Connect to: localhost:$Port" -ForegroundColor Cyan
        Write-Host "  3. Use credentials: kali/testuser with password: 1234" -ForegroundColor Cyan
    } else {
        Write-Host "Failed to start container!" -ForegroundColor Red
        exit 1
    }
}

function Stop-Container {
    Write-Host "Stopping container $ContainerName..." -ForegroundColor Yellow
    docker stop $ContainerName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Container stopped successfully!" -ForegroundColor Green
    }
}

function Restart-Container {
    Stop-Container
    Start-Sleep 2
    Write-Host "Starting container $ContainerName..." -ForegroundColor Green
    docker start $ContainerName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Container restarted successfully!" -ForegroundColor Green
        Start-Sleep 3
        docker logs --tail 20 $ContainerName
    }
}

function Show-Logs {
    Write-Host "Container logs for $ContainerName:" -ForegroundColor Cyan
    docker logs -f $ContainerName
}

function Clean-All {
    Write-Host "Cleaning up container and image..." -ForegroundColor Yellow
    docker stop $ContainerName 2>$null
    docker rm $ContainerName 2>$null
    docker rmi kali 2>$null
    Write-Host "Cleanup completed!" -ForegroundColor Green
}

function Open-Shell {
    Write-Host "Opening shell in Kali container $ContainerName..." -ForegroundColor Green
    
    # Check if container is running
    $running = docker ps --filter "name=$ContainerName" --format "{{.Names}}"
    if (-not $running) {
        Write-Host "Container $ContainerName is not running! Starting it..." -ForegroundColor Yellow
        docker start $ContainerName
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to start container! Cannot open shell." -ForegroundColor Red
            return
        }
        Start-Sleep 3
    }
    
    # Open interactive shell
    Write-Host "Connecting to container..." -ForegroundColor Cyan
    docker exec -it $ContainerName bash
}

# Display current configuration
Write-Host "=== Kali Docker Container Manager ===" -ForegroundColor Green
Write-Host "Action:        $Action" -ForegroundColor DarkGray
Write-Host "Container:     $ContainerName" -ForegroundColor DarkGray
Write-Host "Port:          $Port" -ForegroundColor DarkGray
Write-Host "Minimal Mode:  $($Minimal -eq $true)" -ForegroundColor DarkGray
Write-Host "----------------------------------" -ForegroundColor DarkGray

# Main execution
switch ($Action.ToLower()) {
    "build" { 
        Build-Image 
    }    "run" { 
        # Check if image exists before building
        $imageExists = docker images kali --format "{{.Repository}}"
        if (-not $imageExists) {
            Build-Image
        } else {
            $rebuild = Read-Host "Image already exists. Rebuild? (y/n)"
            if ($rebuild -eq "y" -or $rebuild -eq "Y") {
                Build-Image
            }
        }
        Start-Container 
    }
    "stop" { 
        Stop-Container 
    }
    "restart" { 
        Restart-Container 
    }
    "logs" { 
        Show-Logs 
    }
    "clean" { 
        Clean-All 
    }
    "shell" {
        Open-Shell
    }
    default { 
        Show-Usage 
    }
}
