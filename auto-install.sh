#!/bin/bash
# https://github.com/JaKooLit

Distro="Arch-Hyprland"
Github_URL="https://github.com/JaKooLit/$Distro.git"
Distro_DIR="$HOME/$Distro"

printf "\n%.0s" {1..1}

if ! command -v git &> /dev/null
then
    echo "Git not found! Installing Git..."
    if ! sudo pacman -S --noconfirm git; then
        echo "Failed to install Git. Exiting."
        exit 1
    fi
fi

printf "\n%.0s" {1..1}

if [ -d "$Distro_DIR" ]; then
    echo "$Distro_DIR exists. Updating the repository..."
    cd "$Distro_DIR"
    git stash && git pull
    chmod +x install.sh
    ./install.sh
else
    echo "$Distro_DIR does not exist. Cloning the repository..."
    git clone --depth=1 "$Github_URL" "$Distro_DIR"
    cd "$Distro_DIR"
    chmod +x install.sh
    ./install.sh
fi
