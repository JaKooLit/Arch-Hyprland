#!/bin/bash
# https://github.com/JaKooLit


# Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "Git not found! Installing Git..."    
    sudo pacman -S --no-confirm git
fi

# Define the directory path
Distro_DIR="$HOME/Arch-Hyprland"

# Check if the repository already exists
if [ -d "$Distro_DIR" ]; then
    cd "$Distro_DIR"
    git stash && git pull
    chmod +x install.sh
    ./install.sh
else
    # Clone the repository if it doesn't exist
    echo "$Distro_DIR does not exist. Cloning the repository..."
    git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git "$Distro_DIR"
    cd "$Distro_DIR"
    chmod +x install.sh
    echo "Running install.sh..."
    ./install.sh
fi


