#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing phn — The Phoronix News CLI${NC}"
echo -e "${YELLOW}Works on Alpine, Ubuntu, Arch, Gentoo, Fedora, macOS, Docker... everywhere.${NC}"


if ! command -v php >/dev/null 2>&1; then
    echo -e "${YELLOW}PHP not found → installing with all needed extensions...${NC}"

    if command -v apk >/dev/null 2>&1; then                # Alpine
        sudo apk add --no-cache php83 php83-cli php83-json php83-mbstring php83-openssl php83-xml

    elif command -v apt-get >/dev/null 2>&1; then          # Debian/Ubuntu/Pop!_OS/Linux Mint
        sudo apt-get update -qq
        sudo apt-get install -y php-cli php-xml php-mbstring php-curl php-openssl

    elif command -v dnf >/dev/null 2>&1; then              # Fedora/RHEL/CentOS/Rocky/Alma
        sudo dnf install -y php-cli php-xml php-mbstring php-json php-openssl

    elif command -v pacman >/dev/null 2>&1; then           # Arch Linux / Manjaro / EndeavourOS
        sudo pacman -Sy --noconfirm php

    elif command -v zypper >/dev/null 2>&1; then           # openSUSE
        sudo zypper install -y --no-confirm php8 php8-cli php8-xmlreader php8-mbstring php8-openssl

    elif command -v emerge >/dev/null 2>&1; then           # Gentoo
        sudo emerge --oneshot --noreplace dev-lang/php

    elif command -v xbps-install >/dev/null 2>&1; then     # Void Linux
        sudo xbps-install -Sy php

    elif command -v brew >/dev/null 2>&1; then             # macOS
        brew install php

    else
        echo -e "${RED}Unsupported package manager. Please install PHP + php-xml manually.${NC}"
        exit 1
    fi
else
    echo "PHP already installed"
    
    command -v apk >/dev/null 2>&1 && sudo apk add --no-cache php83-xml 2>/dev/null || true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/phn.php"

if [[ ! -f "$SOURCE_FILE" ]]; then
    echo -e "${RED}Error: phn.php not found in $SCRIPT_DIR${NC}"
    exit 1
fi

sudo mkdir -p /usr/local/bin
sudo rm -f /usr/local/bin/phn 2>/dev/null || true
sudo ln -sf "$SOURCE_FILE" /usr/local/bin/phn
sudo chmod 755 /usr/local/bin/phn

echo -e "${GREEN}Success! phn is now installed globally.${NC}"
echo ""
echo "   Run:  phn"
echo ""
echo "   Uninstall anytime: sudo rm /usr/local/bin/phn"
echo -e "${GREEN}Enjoy your daily Phoronix fix!${NC}"
