#!/bin/bash

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
LOG="install-$(date +%d-%H%M%S)_xdph.log"

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

# XDG-DESKTOP-PORTAL-HYPRLAND

for xdph in xdg-desktop-portal-hyprland; do
  install_package "$xdph" 2>&1 | tee -a "$LOG"
    if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $xdph install had failed, please check the install.log"
    exit 1
    fi
done
    
printf "${NOTE} Checking for other XDG-Desktop-Portal-Implementations....\n"
sleep 1
printf "\n"
printf "${NOTE} XDG-desktop-portal-KDE (if installed) should be manually disabled or removed! I can't remove it... sorry...\n"
read -n1 -rep "${CAT} Would you like me to try to remove other XDG-Desktop-Portal-Implementations? (y/n)" XDPH1
sleep 1
if [[ $XDPH1 =~ ^[Yy]$ ]]; then
    # Clean out other portals
    printf "${NOTE} Clearing any other xdg-desktop-portal implementations...\n"
    # Check if packages are installed and uninstall if present
    if pacman -Qs xdg-desktop-portal-gnome > /dev/null ; then
        echo "Removing xdg-desktop-portal-gnome..."
        sudo pacman -R --noconfirm xdg-desktop-portal-gnome 2>&1 | tee -a $LOG
    fi
    if pacman -Qs xdg-desktop-portal-gtk > /dev/null ; then
        echo "Removing xdg-desktop-portal-gtk..."
        sudo pacman -R --noconfirm xdg-desktop-portal-gtk 2>&1 | tee -a $LOG
    fi
    if pacman -Qs xdg-desktop-portal-wlr > /dev/null ; then
        echo "Removing xdg-desktop-portal-wlr..."
        sudo pacman -R --noconfirm xdg-desktop-portal-wlr 2>&1 | tee -a $LOG
    fi
    if pacman -Qs xdg-desktop-portal-lxqt > /dev/null ; then
        echo "Removing xdg-desktop-portal-lxqt..."
        sudo pacman -R --noconfirm xdg-desktop-portal-lxqt 2>&1 | tee -a $LOG
    fi
fi

clear