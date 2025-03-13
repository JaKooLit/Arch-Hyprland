#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Final checking if packages are installed
# NOTE: These package check are only the essentials

packages=(
  cliphist
  kvantum
  rofi-wayland
  imagemagick
  swaync
  swww
  wallust
  waybar
  wl-clipboard
  wlogout
  kitty
  hypridle
  hyprlock
  hyprland
)

# Local packages that should be in /usr/local/bin/
local_pkgs_installed=(

)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/00_CHECK-$(date +%d-%H%M%S)_installed.log"

printf "\n%s - Final Check if all ${SKY_BLUE}Essential packages${RESET} were installed \n" "${NOTE}"
# Initialize an empty array to hold missing packages
missing=()
local_missing=()

# Function to check if a packages are installed using pacman
is_installed_pacman() {
    pacman -Qi "$1" &>/dev/null
}

# Loop through each package
for pkg in "${packages[@]}"; do
    # Check if the packages are installed
    if ! is_installed_pacman "$pkg"; then
        missing+=("$pkg")
    fi
done

# Check for local packages
for pkg1 in "${local_pkgs_installed[@]}"; do
    if ! [ -f "/usr/local/bin/$pkg1" ]; then
        local_missing+=("$pkg1")
    fi
done

# Log missing packages
if [ ${#missing[@]} -eq 0 ] && [ ${#local_missing[@]} -eq 0 ]; then
    echo "${OK} GREAT! All ${YELLOW}essential packages${RESET} have been successfully installed." | tee -a "$LOG"
else
    if [ ${#missing[@]} -ne 0 ]; then
        echo "${WARN} The following packages are not installed and will be logged:"
        for pkg in "${missing[@]}"; do
            echo "${WARNING}$pkg${RESET}"
            echo "$pkg" >> "$LOG" 
        done
    fi

    if [ ${#local_missing[@]} -ne 0 ]; then
        echo "${WARN} The following local packages are missing from /usr/local/bin/ and will be logged:"
        for pkg1 in "${local_missing[@]}"; do
            echo "${WARNING}$pkg1${REST} is not installed. Can't find it in /usr/local/bin/"
            echo "$pkg1" >> "$LOG" 
        done
    fi

    echo "${NOTE} Missing packages logged at $(date)" >> "$LOG"
fi

