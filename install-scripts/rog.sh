#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Asus ROG Laptops #

rog=(
    power-profiles-daemon
    asusctl
    supergfxctl
    rog-control-center
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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_rog.log"

### Install software for Asus ROG laptops ###

printf " Installing ${SKY_BLUE}ASUS ROG packages${RESET}...\n"
for ASUS in "${rog[@]}"; do
install_package  "$ASUS" "$LOG"
done

printf " Activating ROG services...\n"
sudo systemctl enable supergfxd 2>&1 | tee -a "$LOG"

printf " enabling power-profiles-daemon...\n"
sudo systemctl enable power-profiles-daemon 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}