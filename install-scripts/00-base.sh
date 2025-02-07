#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# base devel + archlinux-keyring #

base=( 
  base-devel
  archlinux-keyring
)
## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_base.log"


# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}base-devel${RESET} \n" "${NOTE}"

for PKG1 in "${base[@]}"; do
  install_package_pacman "$PKG1" "$LOG"
done

printf "\n%.0s" {1..2}