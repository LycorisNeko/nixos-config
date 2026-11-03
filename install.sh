#!/usr/bin/env bash
set -e

# ANSI Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}    NixOS Deployment Script (install.sh)${NC}"
echo -e "${BLUE}=======================================${NC}"

# Navigate to the script's directory (repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. Sync hardware configuration
echo -e "${GREEN}[1/4] Checking hardware configuration...${NC}"
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    echo -e "  Copying /etc/nixos/hardware-configuration.nix -> ./hardware-configuration.nix"
    cp /etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
else
    echo -e "${YELLOW}  [WARN] /etc/nixos/hardware-configuration.nix not found.${NC}"
    if [ -f "./hardware-configuration.nix" ]; then
        echo -e "  Using existing ./hardware-configuration.nix from repository."
    else
        echo -e "${RED}  [ERROR] No hardware-configuration.nix found. Aborting!${NC}"
        exit 1
    fi
fi

# 2. Update flake.lock
echo -e "${GREEN}[2/4] Updating flake lock (nix flake update)...${NC}"
nix flake update --extra-experimental-features "nix-command flakes" || {
    echo -e "${YELLOW}  [WARN] 'nix flake update' encountered an issue, continuing with existing flake.lock...${NC}"
}

# 3. Stage changes to Git
echo -e "${GREEN}[3/4] Staging configuration files to Git...${NC}"
git add -A
echo -e "  All files staged."

# 4. Build and switch NixOS configuration
echo -e "${GREEN}[4/4] Building and switching NixOS configuration...${NC}"
echo -e "${YELLOW}  (Enter sudo password if prompted)${NC}"
sudo nixos-rebuild switch --flake .#

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}  NixOS Deployment Completed!          ${NC}"
echo -e "${GREEN}=======================================${NC}"
echo -e "You can now reboot your system:"
echo -e "  ${BLUE}systemctl reboot${NC}"
