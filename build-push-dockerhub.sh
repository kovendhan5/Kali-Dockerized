#!/bin/bash
# Build and push Kali Docker image to Docker Hub

# Configuration - MODIFY THESE VALUES
DOCKER_HUB_USERNAME=""  # Your Docker Hub username
IMAGE_NAME="kali-dockerized"
IMAGE_VERSION="latest"
BUILD_MINIMAL=false     # Set to true to also build the minimal version

# Color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${GREEN}=== Kali Dockerized - Build and Push to Docker Hub ===${NC}"
echo

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    exit 1
fi

# Check if logged in to Docker Hub
echo -e "${YELLOW}Step 1: Verifying Docker Hub login...${NC}"
if ! docker info | grep -q "Username"; then
    echo "You are not logged in to Docker Hub"
    echo "Please log in to Docker Hub:"
    docker login
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Login failed. Exiting.${NC}"
        exit 1
    fi
fi

# Check if username is set
if [ -z "$DOCKER_HUB_USERNAME" ]; then
    read -p "Enter your Docker Hub username: " DOCKER_HUB_USERNAME
    if [ -z "$DOCKER_HUB_USERNAME" ]; then
        echo -e "${RED}No username provided. Exiting.${NC}"
        exit 1
    fi
fi

# Build the main image
echo -e "${YELLOW}Step 2: Building main Kali Docker image...${NC}"
echo "Building: $DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"
docker build -t "$DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION" .

if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed for main image.${NC}"
    exit 1
else
    echo -e "${GREEN}Main image built successfully!${NC}"
fi

# Build the minimal image if requested
if [ "$BUILD_MINIMAL" = true ]; then
    echo -e "${YELLOW}Step 3: Building minimal Kali Docker image...${NC}"
    echo "Building: $DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal"
    docker build -t "$DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal" -f Dockerfile.minimal .
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Build failed for minimal image.${NC}"
        exit 1
    else
        echo -e "${GREEN}Minimal image built successfully!${NC}"
    fi
fi

# Push images to Docker Hub
echo -e "${YELLOW}Step 4: Pushing images to Docker Hub...${NC}"

echo "Pushing main image: $DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"
docker push "$DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to push main image to Docker Hub.${NC}"
    exit 1
else
    echo -e "${GREEN}Main image pushed successfully!${NC}"
fi

# Push minimal image if it was built
if [ "$BUILD_MINIMAL" = true ]; then
    echo "Pushing minimal image: $DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal"
    docker push "$DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to push minimal image to Docker Hub.${NC}"
        exit 1
    else
        echo -e "${GREEN}Minimal image pushed successfully!${NC}"
    fi
fi

echo
echo -e "${GREEN}All done! Your images are now available on Docker Hub:${NC}"
echo "  • $DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"
if [ "$BUILD_MINIMAL" = true ]; then
    echo "  • $DOCKER_HUB_USERNAME/$IMAGE_NAME:minimal"
fi
echo
echo "You can pull them with:"
echo "  docker pull $DOCKER_HUB_USERNAME/$IMAGE_NAME:$IMAGE_VERSION"
