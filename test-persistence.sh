#!/bin/bash
# Data persistence test for Kali Docker container

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Kali Docker Data Persistence Test ===${NC}"
echo

# Test setup data
TEST_FILE="/home/kali/persistence_test.txt"
TEST_CONTENT="This is a test file created on $(date) to verify container persistence"

# Step 1: Check if container exists
echo -e "${YELLOW}Step 1: Checking if container exists...${NC}"
if docker ps -a | grep -q kali-rdp; then
  echo -e "${GREEN}Container exists${NC}"
  
  # Check if container is running
  if docker ps | grep -q kali-rdp; then
    echo "Container is running"
  else
    echo "Starting container..."
    docker start kali-rdp
    sleep 5
  fi
else
  echo -e "${RED}No container found - please create one first${NC}"
  echo "Run: run-kali.bat"
  exit 1
fi

# Step 2: Create test file
echo -e "\n${YELLOW}Step 2: Creating test file in container...${NC}"
docker exec kali-rdp bash -c "echo '${TEST_CONTENT}' > ${TEST_FILE}"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Test file created successfully:${NC} ${TEST_FILE}"
  echo "File content:"
  docker exec kali-rdp cat ${TEST_FILE}
else
  echo -e "${RED}Failed to create test file${NC}"
  exit 1
fi

# Step 3: Restart container
echo -e "\n${YELLOW}Step 3: Restarting container...${NC}"
docker restart kali-rdp
sleep 5

# Step 4: Verify data persisted
echo -e "\n${YELLOW}Step 4: Verifying data persistence...${NC}"
if docker exec kali-rdp bash -c "[ -f ${TEST_FILE} ] && echo 'File exists'"; then
  echo -e "${GREEN}Test file still exists after container restart!${NC}"
  echo "File content:"
  docker exec kali-rdp cat ${TEST_FILE}
  echo
  echo -e "${GREEN}DATA PERSISTENCE TEST PASSED!${NC}"
  echo "This confirms that your data will be preserved between container restarts."
else
  echo -e "${RED}Test file was not found after restart!${NC}"
  echo "Data persistence is NOT working correctly."
  exit 1
fi

# Optional cleanup
read -p "Remove test file? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  docker exec kali-rdp bash -c "rm ${TEST_FILE}"
  echo "Test file removed"
fi

echo
echo -e "${BLUE}Test complete!${NC}"
