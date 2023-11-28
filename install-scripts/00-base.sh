#!/bin/bash

# https://github.com/JaKooLit

base=( 
  base-devel
)
############## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ######################################

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_base.log"

# Set the script to exit on error
set -e

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if pacman -Q "$1" &>/dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    sudo pacman -S --noconfirm "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is installed
    if pacman -Q "$1" &>/dev/null ; then
      echo -e "${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "${ERROR} $1 failed to install. Please check the $LOG. You may need to install manually."
      exit 1
    fi
  fi
}

# Installation of main components
printf "\n%s - Installing base-devel \n" "${NOTE}"

for PKG1 in "${base[@]}"; do
  install_package "$PKG1" | tee -a "$LOG"
done


# clear
