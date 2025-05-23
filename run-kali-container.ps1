# Enhanced Kali Linux Docker Container Manager
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("build", "run", "stop", "restart", "logs", "clean")]
    [string]$Action = "run",
    
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "kali-rdp"
)

function Show-Usage {
    Write-Host "Usage: .\run-kali-container.ps1 [-Action <action>] [-ContainerName <name>]" -ForegroundColor Yellow
    Write-Host "Actions:" -ForegroundColor Yellow
    Write-Host "  build    - Build the Docker image" -ForegroundColor Cyan
    Write-Host "  run      - Build and run the container (default)" -ForegroundColor Cyan
    Write-Host "  stop     - Stop the running container" -ForegroundColor Cyan
    Write-Host "  restart  - Restart the container" -ForegroundColor Cyan
    Write-Host "  logs     - Show container logs" -ForegroundColor Cyan
    Write-Host "  clean    - Stop and remove container and image" -ForegroundColor Cyan
}

function Build-Image {
    Write-Host "Building Kali Linux Docker image..." -ForegroundColor Green
    docker build -t kali . --no-cache
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Image built successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to build image!" -ForegroundColor Red
        exit 1
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
    Write-Host "Container will be available on RDP port 3389" -ForegroundColor Cyan
    Write-Host "Default credentials: kali/testuser : 1234" -ForegroundColor Cyan
    
    docker run -d -p 3389:3389 --name $ContainerName kali
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Container started successfully!" -ForegroundColor Green
        Start-Sleep 5
        docker logs $ContainerName
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

# Main execution
switch ($Action.ToLower()) {
    "build" { 
        Build-Image 
    }
    "run" { 
        Build-Image
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
    default { 
        Show-Usage 
    }
}
