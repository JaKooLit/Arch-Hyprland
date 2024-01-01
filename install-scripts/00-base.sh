#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# base devel #

base=( 
  base-devel
)
## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_base.log"


set -e

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

## Function for installing packages
install_package_pacman() {
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
  install_package_pacman "$PKG1" | tee -a "$LOG"
done

clear