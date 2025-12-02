#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing phn CLI — with all needed PHP extensions${NC}"

if ! command -v php >/dev/null 2>&1; then
    echo -e "${YELLOW}Installing PHP...${NC}"
    if command -v apk >/dev/null; then
        sudo apk add --no-cache php php-cli php-json php-mbstring php-posix php-pcre
    elif command -v apt-get >/dev/null; then
        sudo apt-get update && sudo apt-get install -y php-cli php-json php-mbstring
    elif command -v dnf >/dev/null; then
        sudo dnf install -y php-cli php-json php-mbstring
    elif command -v pacman >/dev/null; then
        sudo pacman -Sy --noconfirm php
    elif command -v brew >/dev/null; then
        brew install php
    fi
else
    
    if command -v apk >/dev/null; then
        sudo apk add --no-cache php-json php-mbstring php-posix php-pcre 2>/dev/null || true
    fi
fi


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/phn.php"

[[ -f "$SOURCE_FILE" ]] || { echo -e "${RED}phn.php not found!${NC}"; exit 1; }

sudo mkdir -p /usr/local/bin
sudo rm -f /usr/local/bin/phn
sudo ln -sf "$SOURCE_FILE" /usr/local/bin/phn
sudo chmod 755 /usr/local/bin/phn

echo -e "${GREEN}Done! phn is ready.${NC}"
echo "→ Try: phn"
