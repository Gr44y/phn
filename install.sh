#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing phn — Phoronix News CLI${NC}"
echo -e "${YELLOW}Supports Alpine • Ubuntu • Arch • Gentoo • Fedora • openSUSE • Void • macOS • Docker • everything${NC}"

# ——— Install PHP + ALL extensions your script actually needs ———
if ! command -v php >/dev/null 2>&1; then
    echo -e "${YELLOW}Installing PHP + required extensions...${NC}"

    if command -v apk >/dev/null 2>&1; then                  # Alpine Linux (the tricky one)
        sudo apk add --no-cache php83 php83-cli php83-json php83-mbstring php83-openssl php83-xml php83-simplexml
        # Force SimpleXML to load — this is the line that finally fixes Alpine forever
        sudo mkdir -p /etc/php83/conf.d
        echo "extension=simplexml.so" | sudo tee /etc/php83/conf.d/00_simplexml.ini > /dev/null

    elif command -v apt-get >/dev/null 2>&1; then            # Debian / Ubuntu / Pop!_OS
        sudo apt-get update -qq
        sudo apt-get install -y php-cli php-xml php-mbstring php-curl php-openssl

    elif command -v dnf >/dev/null 2>&1; then                # Fedora / RHEL / Rocky / Alma
        sudo dnf install -y php-cli php-xml php-mbstring php-json php-openssl

    elif command -v pacman >/dev/null 2>&1; then             # Arch / Manjaro / EndeavourOS
        sudo pacman -Sy --noconfirm php

    elif command -v emerge >/dev/null 2>&1; then             # Gentoo
        sudo emerge --oneshot dev-lang/php

    elif command -v zypper >/dev/null 2>&1; then             # openSUSE
        sudo zypper install -y --no-confirm php8 php8-cli php8-xmlreader php8-mbstring php8-openssl

    elif command -v xbps-install >/dev/null 2>&1; then       # Void Linux
        sudo xbps-install -Sy php

    elif command -v brew >/dev/null 2>&1; then               # macOS
        brew install php

    else
        echo -e "${RED}Unknown package manager — please install PHP + php-xml manually${NC}"
        exit 1
    fi
else
    echo "PHP already detected"
    # Extra safety net for Alpine if user already had PHP
    if command -v apk >/dev/null 2>&1; then
        sudo apk add --no-cache php83-simplexml 2>/dev/null || true
        echo "extension=simplexml.so" | sudo tee /etc/php83/conf.d/00_simplexml.ini > /dev/null 2>&1 || true
    fi
fi

# ——— Make phn command global ———
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/phn.php"

[[ -f "$SOURCE_FILE" ]] || { echo -e "${RED}phn.php not found!${NC}"; exit 1; }

sudo mkdir -p /usr/local/bin
sudo rm -f /usr/local/bin/phn
sudo ln -sf "$SOURCE_FILE" /usr/local/bin/phn
sudo chmod 755 /usr/local/bin/phn

echo -e "${GREEN}╔══════════════════════════════╗${NC}"
echo -e "${GREEN}║     phn installed perfectly! ║${NC}"
echo -e "${GREEN}╚══════════════════════════════╝${NC}"
echo
echo "   Just type:  phn"
echo
echo "   Uninstall: sudo rm /usr/local/bin/phn"
echo
echo -e "${GREEN}Enjoy your daily Phoronix fix! 🔥${NC}"
