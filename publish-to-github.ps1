# GitHub Container Registry publishing script
# Replace these variables with your own values
$GITHUB_USERNAME = "your-github-username"
$REPOSITORY_NAME = "kali-linux-rdp"
$VERSION = "1.0.0"
$IMAGE_NAME = "kali"

# Display information
Write-Host "Publishing Docker image to GitHub Container Registry" -ForegroundColor Green
Write-Host "GitHub Username: $GITHUB_USERNAME" -ForegroundColor Cyan
Write-Host "Repository: $REPOSITORY_NAME" -ForegroundColor Cyan
Write-Host "Version: $VERSION" -ForegroundColor Cyan

# Build the Docker image
Write-Host "`nBuilding Docker image..." -ForegroundColor Yellow
docker build -t $IMAGE_NAME .

# Tag the image for GitHub Container Registry
$GITHUB_IMAGE_PATH = "ghcr.io/$GITHUB_USERNAME/$REPOSITORY_NAME"
Write-Host "`nTagging image as: $GITHUB_IMAGE_PATH`:$VERSION" -ForegroundColor Yellow
docker tag $IMAGE_NAME "$GITHUB_IMAGE_PATH`:$VERSION"
docker tag $IMAGE_NAME "$GITHUB_IMAGE_PATH`:latest"

# Login to GitHub Container Registry
Write-Host "`nLogging in to GitHub Container Registry..." -ForegroundColor Yellow
Write-Host "You'll need to enter your GitHub Personal Access Token when prompted" -ForegroundColor Yellow
$GITHUB_PAT = Read-Host -Prompt "Enter your GitHub Personal Access Token" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($GITHUB_PAT)
$PAT = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$PAT | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

# Push the image to GitHub Container Registry
Write-Host "`nPushing image to GitHub Container Registry..." -ForegroundColor Yellow
docker push "$GITHUB_IMAGE_PATH`:$VERSION"
docker push "$GITHUB_IMAGE_PATH`:latest"

Write-Host "`nSuccessfully published to GitHub Container Registry!" -ForegroundColor Green
Write-Host "Image URL: ghcr.io/$GITHUB_USERNAME/$REPOSITORY_NAME" -ForegroundColor Cyan
