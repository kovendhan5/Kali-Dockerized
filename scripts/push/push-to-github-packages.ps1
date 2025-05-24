# Push Docker images from Docker Hub to GitHub Packages
Write-Host "=== Pushing Kali Docker Images to GitHub Packages ===" -ForegroundColor Green
Write-Host

$DOCKER_HUB_USERNAME = "kovendhan5"
$GITHUB_USERNAME = "kovendhan5"
$IMAGE_NAME = "kali-dockerized"
$GITHUB_REPO = "kali-dockerized"

Write-Host "This script will help you push Docker images from Docker Hub to GitHub Packages."
Write-Host

# Check if GitHub CLI is installed
$hasGH = $null -ne (Get-Command "gh" -ErrorAction SilentlyContinue)
if (-not $hasGH) {
    Write-Host "GitHub CLI (gh) is not installed or not in PATH."
    Write-Host "You can still proceed with manual authentication."
    Write-Host
}

Write-Host "Logging in to GitHub Container Registry..."
Write-Host "You may be prompted to authenticate."
Write-Host

# Ask user for GitHub token if needed
$GITHUB_TOKEN = Read-Host -Prompt "Enter your GitHub personal access token (or press Enter to use existing auth)"

if (-not [string]::IsNullOrEmpty($GITHUB_TOKEN)) {
    Write-Host "Logging in to GitHub Container Registry with provided token..."
    $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin
} else {
    Write-Host "Using existing GitHub authentication..."
}

Write-Host
Write-Host "Step 1: Pulling images from Docker Hub..." -ForegroundColor Yellow
Write-Host
Write-Host "Pulling Ultra-Slim image..."
docker pull "$DOCKER_HUB_USERNAME/$IMAGE_NAME`:ultraslim"
Write-Host
Write-Host "Pulling Minimal-Optimized image..."
docker pull "$DOCKER_HUB_USERNAME/$IMAGE_NAME`:minimal-optimized"

Write-Host
Write-Host "Step 2: Tagging images for GitHub Packages..." -ForegroundColor Yellow
Write-Host
docker tag "$DOCKER_HUB_USERNAME/$IMAGE_NAME`:ultraslim" "ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME`:ultraslim"
docker tag "$DOCKER_HUB_USERNAME/$IMAGE_NAME`:minimal-optimized" "ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME`:minimal-optimized"

Write-Host
Write-Host "Step 3: Pushing images to GitHub Packages..." -ForegroundColor Yellow
Write-Host

# Try pushing ultra-slim first
Write-Host "Pushing Ultra-Slim image to GitHub Packages..."
docker push "ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME`:ultraslim"

Write-Host
Write-Host "Pushing Minimal-Optimized image to GitHub Packages..."
docker push "ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME`:minimal-optimized"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nPush successful! Your images are now available on GitHub Packages:" -ForegroundColor Green
    Write-Host "https://github.com/$GITHUB_USERNAME/$GITHUB_REPO/pkgs/container/$IMAGE_NAME" -ForegroundColor Cyan
} else {
    Write-Host "`nPush encountered some issues. You might need to check your GitHub authentication." -ForegroundColor Red
}

Write-Host
Write-Host "Remember to set the package visibility to public in GitHub if you want others to use it."
Write-Host

Read-Host -Prompt "Press Enter to continue"
