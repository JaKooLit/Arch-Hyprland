#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Main Hyprland Package #

hypr_eco=(
  hypridle
  hyprlock
)

hypr=(
  hyprland
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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hyprland.log"

# Check if Hyprland is installed
if command -v Hyprland >/dev/null 2>&1; then
  printf "$NOTE - ${YELLOW} Hyprland is already installed.${RESET} No action required.\n"
else
  printf "$INFO - Hyprland not found. ${SKY_BLUE} Installing Hyprland...${RESET}\n"
  for HYPRLAND in "${hypr[@]}"; do
    install_package "$HYPRLAND" "$LOG"
  done
fi

# Hyprland -eco packages
printf "${NOTE} - Installing ${SKY_BLUE}other Hyprland-eco packages${RESET} .......\n"
for HYPR in "${hypr_eco[@]}"; do
  if ! command -v "$HYPR" >/dev/null 2>&1; then
    printf "$INFO - ${YELLOW}$HYPR${RESET} not found. Installing ${YELLOW}$HYPR...${RESET}\n"
    install_package "$HYPR" "$LOG"
  else
    printf "$NOTE - ${YELLOW} $HYPR is already installed.${RESET} No action required.\n"
  fi
done

printf "\n%.0s" {1..2}