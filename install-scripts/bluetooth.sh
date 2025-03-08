#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Bluetooth Stuff #

blue=(
  bluez
  bluez-utils
  blueman
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi



# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_bluetooth.log"

# Bluetooth
printf "${NOTE} Installing ${SKY_BLUE}Bluetooth${RESET} Packages...\n"
 for BLUE in "${blue[@]}"; do
   install_package "$BLUE" "$LOG"
  done

printf " Activating ${YELLOW}Bluetooth${RESET} Services...\n"
sudo systemctl enable --now bluetooth.service 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}