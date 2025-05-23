# Build and Push Kali Docker Images to Docker Hub
# PowerShell version for Windows environments

# Configuration - MODIFY THESE VALUES
$DOCKER_HUB_USERNAME = "kovendhan5"  # Your Docker Hub username
$IMAGE_NAME = "kali-dockerized"
$IMAGE_VERSION = "latest"
$BUILD_MINIMAL = $true    # Set to $true to also build the minimal version

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
    Write-Host "Building: ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_VERSION}"
    
    docker build -t "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_VERSION}" .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed for main image." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "Main image built successfully!" -ForegroundColor Green
    }
}

function Build-MinimalImage {
    Write-Host "`nStep 3: Building minimal Kali Docker image..." -ForegroundColor Yellow
    Write-Host "Building: ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:minimal"
    
    docker build -t "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:minimal" -f Dockerfile.minimal .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed for minimal image." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "Minimal image built successfully!" -ForegroundColor Green
    }
}

function Push-Images {
    Write-Host "`nStep 4: Pushing images to Docker Hub..." -ForegroundColor Yellow
    
    # Push main image with retries
    Push-ImageWithRetry -ImageName "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_VERSION}" -MaxRetries 5
    
    # Push minimal image if it was built
    if ($BUILD_MINIMAL) {
        Push-ImageWithRetry -ImageName "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:minimal" -MaxRetries 5
    }
}

function Push-ImageWithRetry {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ImageName,
        
        [Parameter(Mandatory = $false)]
        [int]$MaxRetries = 3,
        
        [Parameter(Mandatory = $false)]
        [int]$RetryDelaySec = 30
    )
    
    Write-Host "Pushing image: $ImageName" -ForegroundColor Cyan
    
    $retryCount = 0
    $success = $false
    
    while (-not $success -and $retryCount -lt $MaxRetries) {
        if ($retryCount -gt 0) {
            Write-Host "Retry attempt $retryCount of $MaxRetries after $RetryDelaySec seconds..." -ForegroundColor Yellow
            Start-Sleep -Seconds $RetryDelaySec
        }
        
        try {
            # Using --disable-content-trust for larger images
            $pushOutput = docker push $ImageName --disable-content-trust 2>&1
            
            # Check if the push was successful
            if ($LASTEXITCODE -eq 0) {
                $success = $true
                Write-Host "Image $ImageName pushed successfully!" -ForegroundColor Green
            }
            else {
                $retryCount++
                Write-Host "Push failed. Error code: $LASTEXITCODE" -ForegroundColor Red
                Write-Host $pushOutput -ForegroundColor Red
            }
        }
        catch {
            $retryCount++
            Write-Host "Exception during push: $_" -ForegroundColor Red
        }
    }
    
    if (-not $success) {
        Write-Host "Failed to push $ImageName to Docker Hub after $MaxRetries attempts." -ForegroundColor Red
        Write-Host "You may want to try the manual push command:" -ForegroundColor Yellow
        Write-Host "docker push $ImageName --disable-content-trust" -ForegroundColor Cyan
        return $false
    }
    
    return $true
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
Write-Host "https://hub.docker.com/r/${DOCKER_HUB_USERNAME}/${IMAGE_NAME}" -ForegroundColor Cyan
Write-Host "`nYou can pull them using:" -ForegroundColor Yellow
Write-Host "  docker pull ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_VERSION}" -ForegroundColor Cyan
if ($BUILD_MINIMAL) {
    Write-Host "  docker pull ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:minimal" -ForegroundColor Cyan
}
