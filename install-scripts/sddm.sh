#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# SDDM Log-in Manager #

sddm=(
  qt6-5compat 
  qt6-declarative 
  qt6-svg
  sddm
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm.log"


# Install SDDM and SDDM theme
printf "${NOTE} Installing sddm and dependencies........\n"
  for package in "${sddm[@]}"; do
  install_package "$package" "$LOG"
  done 

# Check if other login managers installed and disabling its service before enabling sddm
for login_manager in lightdm gdm3 gdm lxdm xdm lxdm-gtk3; do
  if pacman -Qs "$login_manager" > /dev/null; then
    echo "disabling $login_manager..."
    sudo systemctl disable "$login_manager.service" 2>&1 | tee -a "$LOG"
    echo "$login_manager disabled."
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

printf "\n%.0s" {1..2}