#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# XDG-Desktop-Portals hyprland #

if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

xdg=(
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    umockdev
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_xdph.log"

# XDG-DESKTOP-PORTAL-HYPRLAND
for xdgs in "${xdg[@]}"; do
  install_package "$xdgs" "$LOG"
    if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $xdph Package installation failed, Please check the installation logs"
    exit 1
    fi
done
    
printf "\n%.0s" {1..2}
