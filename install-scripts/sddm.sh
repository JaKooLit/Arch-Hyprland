#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# SDDM Log-in Manager #

sddm=(
  qt6-declarative
  qt6-svg
  qt6-virtualkeyboard
  qt6-multimedia-ffmpeg
  qt5-quickcontrols2
  sddm
)

# login managers to attempt to disable
login=(
  lightdm
  gdm3
  gdm
  lxdm
  lxdm-gtk3
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || {
  echo "${ERROR} Failed to change directory to $PARENT_DIR"
  exit 1
}

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm.log"

# Install SDDM and SDDM theme
printf "${NOTE} Installing sddm and dependencies........\n"
for package in "${sddm[@]}"; do
  install_package "$package" "$LOG"
done

printf "\n%.0s" {1..1}

# Check if other login managers installed and disabling its service before enabling sddm
for login_manager in "${login[@]}"; do
  if pacman -Qs "$login_manager" >/dev/null 2>&1; then
    sudo systemctl disable "$login_manager.service" >>"$LOG" 2>&1
    echo "$login_manager disabled." >>"$LOG" 2>&1
  fi
done

# Double check with systemctl
for manager in "${login[@]}"; do
  if systemctl is-active --quiet "$manager" >/dev/null 2>&1; then
    echo "$manager is active, disabling it..." >>"$LOG" 2>&1
    sudo systemctl disable "$manager" --now >>"$LOG" 2>&1
  fi
done

printf "\n%.0s" {1..1}
printf "${INFO} Activating sddm service........\n"
sudo systemctl enable sddm

wayland_sessions_dir=/usr/share/wayland-sessions
[ ! -d "$wayland_sessions_dir" ] && {
  printf "$CAT - $wayland_sessions_dir not found, creating...\n"
  sudo mkdir "$wayland_sessions_dir" 2>&1 | tee -a "$LOG"
}

printf "\n%.0s" {1..2}

