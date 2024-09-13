#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Final checking if packages are installed
# NOTE: These package check are only the essentials

packages=(
  aylurs-gtk-shell
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
  pyprland 
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/00_CHECK-$(date +%d-%H%M%S)_installed.log"


printf "\n%s - Final Check if packages where installed \n" "${NOTE}"
# Initialize an empty array to hold missing packages
missing=()

# Loop through each package
for pkg in "${packages[@]}"; do
    # Check if the package is installed
    if ! pacman -Qi "$pkg" > /dev/null 2>&1; then
        missing+=("$pkg")
    fi
done

# Check if the missing array is empty or not
if [ ${#missing[@]} -eq 0 ]; then
    echo "${OK} All essential packages are installed." | tee -a "$LOG"
else
    # Message to user on missing packages
    echo "${WARN} The following packages are missing and will be logged:"
    
    # Log only the missing packages and inform the user
    for pkg in "${missing[@]}"; do
        echo "$pkg"
        echo "$pkg" >> "$LOG" # Log the missing package to the file
    done
    
    # Add a timestamp when the missing packages were logged
    echo "${NOTE} Missing packages logged at $(date)" >> "$LOG"
fi

