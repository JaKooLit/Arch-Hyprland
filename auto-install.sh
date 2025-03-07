#!/bin/bash
# https://github.com/JaKooLit


# Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "Git not found! Installing Git..."    
    sudo pacman -S --no-confirm git
fi

# Clone the repository
echo "Cloning the repository..."
git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git -b development ~/Arch-Hyprland
cd ~/Arch-Hyprland
chmod +x install.sh
./install.sh

