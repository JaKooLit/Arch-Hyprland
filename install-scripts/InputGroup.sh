#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Adding users into input group #

if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_input.log"

while true; do
    echo "${WARN} This script will add your ${YELLOW}user${RESET} to the ${MAGENTA}input${RESET} group."
    echo "${NOTE} Please note that adding yourself to the ${MAGENTA}input${RESET} group might be necessary for ${MAGENTA}waybar keyboard-state functionality${RESET} ."
    
    printf "\n%.0s" {1..1}
    
    if [[ -z $input_group_choid ]]; then
      read -p "${YELLOW}Do you want to proceed? (y/n): ${RESET}" input_group_choid
    fi

    if [[ $input_group_choid == "y" || $input_group_choid == "Y" ]]; then
        if grep -q '^input:' /etc/group; then
            echo "${OK} ${MAGENTA}input${RESET} group exists."
        else
            echo "${NOTE} ${MAGENTA}input${RESET} group doesn't exist. Creating ${MAGENTA}input${RESET} group..."
            sudo groupadd input

            echo "${MAGENTA}input${RESET} group created" >> "$LOG"
        fi

        sudo usermod -aG input "$(whoami)"
        echo "${OK} ${YELLOW}user${RESET} added to the ${MAGENTA}input${RESET} group. Changes will take effect after you log out and log back in."

        echo "User added to 'input' group" >> "$LOG"
        break 
    elif [[ $input_group_choid == "n" || $input_group_choid == "N" ]]; then
        echo "${NOTE} No changes made. Exiting the script."
        break 
    else
        echo "${ERROR} Invalid choice. Please enter 'y' for yes or 'n' for no."
    fi
done

printf "\n%.0s" {1..2}