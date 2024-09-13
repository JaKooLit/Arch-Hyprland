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

############## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##############
# Set some colors for output messages
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_pipewire.log"

ISAUR=$(command -v yay || command -v paru)

# Disabling pulseaudio to avoid conflicts
systemctl --user disable --now pulseaudio.socket pulseaudio.service 2>/dev/null && tee -a "$LOG"

# Pipewire
printf "${NOTE} Installing Pipewire Packages...\n"
for PIPEWIRE in "${pipewire[@]}"; do
    install_package "$PIPEWIRE" 2>&1 | tee -a "$LOG"
    [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $PIPEWIRE Package installation failed, Please check the installation logs"; exit 1; }
done

printf "Activating Pipewire Services...\n"
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service 2>&1 | tee -a "$LOG"
systemctl --user enable --now pipewire.service 2>&1 | tee -a "$LOG"


clear