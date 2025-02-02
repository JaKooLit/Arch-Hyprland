#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Bluetooth Stuff #

blue=(
  bluez
  bluez-utils
  blueman
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_bluetooth.log"

# Bluetooth
printf "${NOTE} Installing ${BLUE}Bluetooth${RESET} Packages...\n"
 for BLUE in "${blue[@]}"; do
   install_package "$BLUE" "$LOG"
  done

printf " Activating ${YELLOW}Bluetooth${RESET} Services...\n"
sudo systemctl enable --now bluetooth.service 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}