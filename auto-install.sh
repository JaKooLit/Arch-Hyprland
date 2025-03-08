#!/bin/bash
# https://github.com/JaKooLit

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

# Variables
Distro="Arch-Hyprland"
Github_URL="https://github.com/JaKooLit/$Distro.git"
Distro_DIR="$HOME/$Distro"

printf "\n%.0s" {1..1}

if ! command -v git &> /dev/null
then
    echo "${INFO} Git not found! ${SKY_BLUE}Installing Git...${RESET}"
    if ! sudo pacman -S git --noconfirm; then
        echo "${ERROR} Failed to install Git. Exiting."
        exit 1
    fi
fi

printf "\n%.0s" {1..1}

if [ -d "$Distro_DIR" ]; then
    echo "${YELLOW}$Distro_DIR exists. Updating the repository... ${RESET}"
    cd "$Distro_DIR"
    git stash && git pull
    chmod +x install.sh
    ./install.sh
else
    echo "${MAGENTA}$Distro_DIR does not exist. Cloning the repository...${RESET}"
    git clone --depth=1 "$Github_URL" "$Distro_DIR"
    cd "$Distro_DIR"
    chmod +x install.sh
    ./install.sh
fi
