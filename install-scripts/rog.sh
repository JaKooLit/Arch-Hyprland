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
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_rog.log"

### Install software for Asus ROG laptops ###

printf " Installing ${BLUE}ASUS ROG packages${RESET}...\n"
for ASUS in "${rog[@]}"; do
install_package  "$ASUS" "$LOG"
  if [ $? -ne 0 ]; then
  exit 1
  fi
done

printf " Activating ROG services...\n"
sudo systemctl enable supergfxd 2>&1 | tee -a "$LOG"

printf " enabling power-profiles-daemon...\n"
sudo systemctl enable power-profiles-daemon 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}