#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Installing phn CLI tool globally...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/phn.php"

if [[ ! -f "$SOURCE_FILE" ]]; then
    echo -e "${RED}Error: phn.php not found in $SCRIPT_DIR${NC}"
    echo "Make sure you're running this from inside the cloned repo."
    exit 1
fi
sudo mkdir -p /usr/local/bin
sudo rm -f /usr/local/bin/phn

sudo ln -s "$SOURCE_FILE" /usr/local/bin/phn
sudo chmod 755 /usr/local/bin/phn

echo -e "${GREEN}Success! You can now run 'phn' from anywhere.${NC}"
echo ""
echo "Uninstall anytime with: sudo rm /usr/local/bin/phn"
