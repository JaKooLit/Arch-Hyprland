#!/bin/bash

thunar=(
thunar 
thunar-volman 
tumbler
ffmpegthumbnailer 
thunar-archive-plugin
)

############## WARNING DO NOT EDIT BEYOND THIS LINE if you dont know what you are doing! ######################################

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_thunar.log"


ISAUR=$(command -v yay || command -v paru)

# Set the script to exit on error
set -e

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    $ISAUR -S --noconfirm "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is installed
    if $ISAUR -Q "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
      exit 1
    fi
  fi
}

# Bluetooth

printf "${NOTE} Installing Thunar Packages...\n"  
  for THUNAR in "${thunar[@]}"; do
    install_package "$THUNAR" 2>&1 | tee -a "$LOG"
    [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $THUNAR install had failed, please check the install.log"; exit 1; }
  done

  # Check for existing config folders and backup
  for DIR1 in Thunar xfce4; do
    DIRPATH=~/.config/$DIR1
    if [ -d "$DIRPATH" ]; then
      echo -e "${NOTE} Config for $DIR1 found, backing up."
      mv $DIRPATH $DIRPATH-back-up 2>&1 | tee -a "$LOG"
      echo -e "${NOTE} Backed up $DIR1 to $DIRPATH-back-up."
    fi
  done

# copying from assets
cp -r assets/xfce4 ~/.config/ && echo "Copy xfce4 completed!" || echo "Error: Failed to copy xfce4 config files." 2>&1 | tee -a "$LOG"
cp -r assets/Thunar ~/.config/ && echo "Copy Thunar completed!" || echo "Error: Failed to copy Thunar config files." 2>&1 | tee -a "$LOG"

clear
