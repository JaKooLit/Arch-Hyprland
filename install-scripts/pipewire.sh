#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Pipewire and Pipewire Audio Stuff #

pipewire=(
    pipewire
    wireplumber
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
    sof-firmware
)

# added this as some reports script didnt install this.
# basically force reinstall
pipewire_2=(
    pipewire-pulse
)

############## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##############
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_pipewire.log"

# Disabling pulseaudio to avoid conflicts and logging output
echo -e "${NOTE} Disabling pulseaudio to avoid conflicts..."
systemctl --user disable --now pulseaudio.socket pulseaudio.service >> "$LOG" 2>&1 || true

# Pipewire
echo -e "${NOTE} Installing ${SKY_BLUE}Pipewire${RESET} Packages..."
for PIPEWIRE in "${pipewire[@]}"; do
    install_package "$PIPEWIRE" "$LOG"
done

for PIPEWIRE2 in "${pipewire_2[@]}"; do
    install_package_pacman "$PIPEWIRE" "$LOG"
done

echo -e "${NOTE} Activating Pipewire Services..."
# Redirect systemctl output to log file
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service 2>&1 | tee -a "$LOG"
systemctl --user enable --now pipewire.service 2>&1 | tee -a "$LOG"

echo -e "\n${OK} Pipewire Installation and services setup complete!" 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
