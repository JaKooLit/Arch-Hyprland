#!/bin/bash

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
LOG="install-$(date +%d-%H%M%S)_sddm.log"

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

# SDDM

  # Check if SDDM is already installed
  if pacman -Qs sddm > /dev/null; then
    # Prompt user to manually install sddm-git to remove SDDM
    read -n1 -rep "SDDM is already installed. Would you like to manually install sddm-git to remove it? This requires manual intervention. (y/n)" manual_install_sddm
    echo
    if [[ $manual_install_sddm =~ ^[Yy]$ ]]; then
      $ISAUR -S sddm-git 2>&1 | tee -a "$LOG"
    fi
  fi

  # Install SDDM and Catppuccin theme
  printf "${NOTE} Installing SDDM-git........\n"
  for package in sddm-git; do
    install_package "$package" 2>&1 | tee -a "$LOG"
    [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $package install has failed, please check the install.log"; exit 1; }
  done 

  # Check if other login managers installed and disabling its service before enabling sddm
  for login_manager in lightdm gdm lxdm lxdm-gtk3; do
    if pacman -Qs "$login_manager" > /dev/null; then
      echo "disabling $login_manager..."
      sudo systemctl disable "$login_manager.service" 2>&1 | tee -a "$LOG"
    fi
  done

  printf " Activating sddm service........\n"
  sudo systemctl enable sddm

  # Set up SDDM
  echo -e "${NOTE} Setting up the login screen."
  sddm_conf_dir=/etc/sddm.conf.d
  [ ! -d "$sddm_conf_dir" ] && { printf "$CAT - $sddm_conf_dir not found, creating...\n"; sudo mkdir "$sddm_conf_dir" 2>&1 | tee -a "$LOG"; }

  wayland_sessions_dir=/usr/share/wayland-sessions
  [ ! -d "$wayland_sessions_dir" ] && { printf "$CAT - $wayland_sessions_dir not found, creating...\n"; sudo mkdir "$wayland_sessions_dir" 2>&1 | tee -a "$LOG"; }
  sudo cp assets/hyprland.desktop "$wayland_sessions_dir/" 2>&1 | tee -a "$LOG"
    
  # SDDM-themes
  read -n1 -rep "${CAT} OPTIONAL - Would you like to install SDDM themes? (y/n)" install_sddm_theme
  if [[ $install_sddm_theme =~ ^[Yy]$ ]]; then
    while true; do
      read -rp "${CAT} Which SDDM Theme you want to install? Catpuccin or Tokyo Night 'c' or 't': " choice 
      case "$choice" in
        c|C)
          printf "\n%s - Installing Catpuccin SDDM Theme\n" "${NOTE}"
          for sddm_theme in sddm-catppuccin-git; do
            install_package "$sddm_theme" 2>&1 | tee -a "$LOG"
            [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $sddm_theme install has failed, please check the install.log"; }
          done
          echo -e "[Theme]\nCurrent=catppuccin" | sudo tee -a "$sddm_conf_dir/10-theme.conf" 2>&1 | tee -a "$LOG"                		
          break
          ;;
        t|T)
          printf "\n%s - Installing Tokyo SDDM Theme\n" "${NOTE}"
          for sddm_theme in sddm-theme-tokyo-night; do
            install_package "$sddm_theme" 2>&1 | tee -a "$LOG"
            [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $sddm_theme install has failed, please check the install.log"; }
          done	
          echo -e "[Theme]\nCurrent=tokyo-night-sddm" | sudo tee -a "$sddm_conf_dir/10-theme.conf" 2>&1 | tee -a "$LOG"                		
          break
          ;;                		
        *)
          printf "%s - Invalid choice. Please enter 'c' or 't'\n" "${ERROR}"
          continue
          ;;
      esac
    done
  fi

  clear