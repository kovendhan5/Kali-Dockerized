#!/bin/bash
# Setup script for Linux users

echo "Setting up permissions for scripts..."
chmod +x start-xrdp.sh
chmod +x fix-gpg-keys.sh

# Create Linux convenience script
cat > run-kali.sh << 'EOL'
#!/bin/bash

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

ACTION="run"
CONTAINER_NAME="kali-rdp"
PORT=3389
MINIMAL=0

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    build|run|stop|restart|shell|logs|clean)
      ACTION="$1"
      ;;
    minimal)
      MINIMAL=1
      ;;
    --port)
      PORT="$2"
      shift
      ;;
    --name)
      CONTAINER_NAME="$2"
      shift
      ;;
    --help)
      echo -e "${GREEN}Kali Docker Container Manager${NC}"
      echo
      echo "Usage: $0 [action] [options]"
      echo
      echo -e "${CYAN}Actions:${NC}"
      echo "  build    - Build the Docker image only"
      echo "  run      - Build and run the container (default)"
      echo "  stop     - Stop the running container"
      echo "  restart  - Restart the container"
      echo "  shell    - Open a shell into the running container"
      echo "  logs     - Show container logs"
      echo
      echo -e "${CYAN}Options:${NC}"
      echo "  minimal     - Use minimal image (faster, fewer tools)"
      echo "  --port N    - Map RDP to port N (default: 3389)"
      echo "  --name NAME - Use custom container name"
      echo
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

echo -e "${GREEN}=== Kali Docker Container Manager ===${NC}"
echo -e "Action:        $ACTION"
echo -e "Container:     $CONTAINER_NAME"
echo -e "Port:          $PORT"
echo -e "Minimal Mode:  $MINIMAL"
echo -e "----------------------------------"

build_image() {
  echo -e "${GREEN}Building Kali Linux Docker image...${NC}"
  
  if [ $MINIMAL -eq 1 ]; then
    DOCKERFILE="Dockerfile.minimal"
    echo "Using minimal Dockerfile"
  else
    DOCKERFILE="Dockerfile"
    echo "Using full Dockerfile"
  fi
  
  docker build -t kali -f $DOCKERFILE . --no-cache
  
  if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Failed to build with primary dockerfile. Trying alternative...${NC}"
    
    if [ -f "Dockerfile.alternative" ]; then
      docker build -t kali -f Dockerfile.alternative . --no-cache
      
      if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to build image with alternative Dockerfile!${NC}"
        exit 1
      else
        echo -e "${GREEN}Image built successfully with alternative Dockerfile!${NC}"
      fi
    else
      echo -e "${RED}Failed to build image and no alternative Dockerfile found!${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}Image built successfully!${NC}"
  fi
}

start_container() {
  # Check if container already exists
  if docker ps -a --filter name=$CONTAINER_NAME | grep -q $CONTAINER_NAME; then
    echo -e "${YELLOW}Container $CONTAINER_NAME already exists. Stopping and removing...${NC}"
    docker stop $CONTAINER_NAME &>/dev/null
    docker rm $CONTAINER_NAME &>/dev/null
  fi
  
  echo -e "${GREEN}Starting Kali Linux container...${NC}"
  echo -e "${CYAN}Container will be available on RDP port $PORT${NC}"
  echo -e "${CYAN}Default credentials: kali/testuser : 1234${NC}"
  
  # Check if we want to mount the current directory
  read -p "Do you want to mount the current directory into the container? (y/n) " VOLUME_PROMPT
  VOLUME_MOUNT=""
  if [[ $VOLUME_PROMPT == "y" || $VOLUME_PROMPT == "Y" ]]; then
    CURRENT_DIR=$(pwd)
    VOLUME_MOUNT="-v ${CURRENT_DIR}:/shared"
    echo -e "${CYAN}Mounting $CURRENT_DIR to /shared in the container${NC}"
  fi
  
  docker run -d -p $PORT:3389 $VOLUME_MOUNT --name $CONTAINER_NAME kali
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Container started successfully!${NC}"
    sleep 5
    docker logs $CONTAINER_NAME
    
    echo -e "\n${GREEN}Access via RDP:${NC}"
    echo -e "  1. Open Remote Desktop Connection"
    echo -e "  2. Connect to: localhost:$PORT"
    echo -e "  3. Use credentials: kali/testuser with password: 1234"
  else
    echo -e "${RED}Failed to start container!${NC}"
    exit 1
  fi
}

case $ACTION in
  build)
    build_image
    ;;
  run)
    # Check if image exists
    if ! docker images | grep -q kali; then
      build_image
    else
      read -p "Image already exists. Rebuild? (y/n) " REBUILD
      if [[ $REBUILD == "y" || $REBUILD == "Y" ]]; then
        build_image
      fi
    fi
    start_container
    ;;
  stop)
    echo "Stopping Kali container $CONTAINER_NAME..."
    docker stop $CONTAINER_NAME
    ;;
  restart)
    echo "Restarting Kali container $CONTAINER_NAME..."
    docker restart $CONTAINER_NAME
    sleep 5
    docker logs --tail 10 $CONTAINER_NAME
    ;;
  shell)
    echo "Opening shell in Kali container $CONTAINER_NAME..."
    docker exec -it $CONTAINER_NAME bash
    ;;
  logs)
    echo "Showing logs for Kali container $CONTAINER_NAME..."
    docker logs -f $CONTAINER_NAME
    ;;
  clean)
    echo "Cleaning up container and image..."
    docker stop $CONTAINER_NAME 2>/dev/null
    docker rm $CONTAINER_NAME 2>/dev/null
    docker rmi kali 2>/dev/null
    echo "Cleanup completed!"
    ;;
esac
EOL

chmod +x run-kali.sh

echo "Setup complete. You can now run:"
echo "  - ./run-kali.sh (for Linux users)"
echo "  - run-kali.bat (for Windows users)"
echo "  - kali-quickstart.bat (for easy Windows startup)"
