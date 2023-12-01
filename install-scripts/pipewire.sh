#!/bin/bash

pipewire=(
    pipewire
    wireplumber
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
)

############## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##############
# Set some colors for output messages
OK=$(tput setaf 2)[OK]$(tput sgr0)
ERROR=$(tput setaf 1)[ERROR]$(tput sgr0)
NOTE=$(tput setaf 3)[NOTE]$(tput sgr0)
WARN=$(tput setaf 166)[WARN]$(tput sgr0)
CAT=$(tput setaf 6)[ACTION]$(tput sgr0)
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_bluetooth.log"

ISAUR=$(command -v yay || command -v paru)

# Set the script to exit on error
set -e

# Function for installing packages
install_package() {
    # Checking if the package is already installed
    if $ISAUR -Q "$1" &>>/dev/null; then
        echo -e "${OK} $1 is already installed. Skipping..."
    else
        # Package not installed
        echo -e "${NOTE} Installing $1 ..."
        $ISAUR -S --noconfirm "$1" 2>&1 | tee -a "$LOG"
        # Making sure the package is installed
        if $ISAUR -Q "$1" &>>/dev/null; then
            echo -e "\e[1A\e[K${OK} $1 was installed."
        else
            # Something is missing, exiting to review the log
            echo -e "\e[1A\e[K${ERROR} $1 failed to install. Please check the install.log. You may need to install manually! Sorry I have tried :("
            exit 1
        fi
    fi
}

# Removal of pulseaudio
printf "${YELLOW}Removing pulseaudio stuff...${RESET}\n"
for pulseaudio in pulseaudio pulseaudio-alsa pulseaudio-bluetooth; do
    sudo pacman -R --noconfirm "$pulseaudio" 2>/dev/null | tee -a "$LOG" || true
done

# Disabling pulseaudio to avoid conflicts
systemctl --user disable --now pulseaudio.socket pulseaudio.service 2>&1 | tee -a "$LOG"

# Pipewire
printf "${NOTE} Installing Pipewire Packages...\n"
for PIPEWIRE in "${pipewire[@]}"; do
    install_package "$PIPEWIRE" 2>&1 | tee -a "$LOG"
    [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $PIPEWIRE install had failed. Please check the install.log"; exit 1; }
done

printf "Activating Pipewire Services...\n"
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service 2>&1 | tee -a "$LOG"
systemctl --user enable --now pipewire.service 2>&1 | tee -a "$LOG"

clear
