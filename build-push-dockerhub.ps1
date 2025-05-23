# Build and Push Kali Docker Images to Docker Hub
# PowerShell version for Windows environments

# Configuration - MODIFY THESE VALUES
$DOCKER_HUB_USERNAME = ""  # Your Docker Hub username
$IMAGE_NAME = "kali-dockerized"
$IMAGE_VERSION = "latest"
$BUILD_MINIMAL = $false    # Set to $true to also build the minimal version

# Check if Docker is installed
try {
    $null = Get-Command docker -ErrorAction Stop
}
catch {
    Write-Host "Error: Docker is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Helper functions
function Show-Header {
    Write-Host "`n=== Kali Dockerized - Build and Push to Docker Hub ===" -ForegroundColor Green
    Write-Host
}

function Check-DockerHubLogin {
    Write-Host "Step 1: Verifying Docker Hub login..." -ForegroundColor Yellow
    
    # Check if logged in to Docker Hub by querying docker info
    $dockerInfo = docker info 2>&1
    if ($dockerInfo -notlike "*Username*") {
        Write-Host "You are not logged in to Docker Hub"
        Write-Host "Please log in to Docker Hub:"
        docker login
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Login failed. Exiting." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Already logged in to Docker Hub" -ForegroundColor Green
    }
}

function Get-DockerHubUsername {
    if ([string]::IsNullOrEmpty($DOCKER_HUB_USERNAME)) {
        $script:DOCKER_HUB_USERNAME = Read-Host -Prompt "Enter your Docker Hub username"
        if ([string]::IsNullOrEmpty($DOCKER_HUB_USERNAME)) {
            Write-Host "No username provided. Exiting." -ForegroundColor Red
            exit 1
        }
    }
    
    Write-Host "Using Docker Hub username: $DOCKER_HUB_USERNAME"
}

function Build-MainImage {
    Write-Host "`nStep 2: Building main Kali Docker image..." -ForegroundColor Yellow
    Write-Host "Building: $DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"
    
    docker build -t "$DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION" .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed for main image." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "Main image built successfully!" -ForegroundColor Green
    }
}

function Build-MinimalImage {
    Write-Host "`nStep 3: Building minimal Kali Docker image..." -ForegroundColor Yellow
    Write-Host "Building: $DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal"
    
    docker build -t "$DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal" -f Dockerfile.minimal .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed for minimal image." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "Minimal image built successfully!" -ForegroundColor Green
    }
}

function Push-Images {
    Write-Host "`nStep 4: Pushing images to Docker Hub..." -ForegroundColor Yellow
    
    # Push main image
    Write-Host "Pushing main image: $DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"
    docker push "$DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to push main image to Docker Hub." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "Main image pushed successfully!" -ForegroundColor Green
    }
    
    # Push minimal image if it was built
    if ($BUILD_MINIMAL) {
        Write-Host "Pushing minimal image: $DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal"
        docker push "$DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal"
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to push minimal image to Docker Hub." -ForegroundColor Red
            exit 1
        } else {
            Write-Host "Minimal image pushed successfully!" -ForegroundColor Green
        }
    }
}

# Main execution flow
Show-Header
Check-DockerHubLogin
Get-DockerHubUsername
Build-MainImage

if ($BUILD_MINIMAL) {
    Build-MinimalImage
}

Push-Images

Write-Host "`nAll done! Your images are now available on Docker Hub:" -ForegroundColor Green
Write-Host "https://hub.docker.com/r/$DOCKER_HUB_USERNAME/$IMAGE_NAME" -ForegroundColor Cyan
Write-Host "`nYou can pull them using:" -ForegroundColor Yellow
Write-Host "  docker pull $DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION" -ForegroundColor Cyan
if ($BUILD_MINIMAL) {
    Write-Host "  docker pull $DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal" -ForegroundColor Cyan
}
