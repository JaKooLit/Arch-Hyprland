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

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_base.log"


# Installation of main components
printf "\n%s - Installing base-devel \n" "${NOTE}"

for PKG1 in "${base[@]}"; do
  install_package_pacman "$PKG1" | tee -a "$LOG"
done



echo -e "${NOTE} Adding Extra Spice in pacman.conf ... ${RESET}" 2>&1 | tee -a "$LOG"
pacman_conf="/etc/pacman.conf"

# Remove comments '#' from specific lines
lines_to_edit=(
    "color"
    "CheckSpace"
    "VerbosePkgLists"
    "ParallelDownloads"
)

# Uncomment specified lines if they are commented out
for line in "${lines_to_edit[@]}"; do
    if grep -q "^#$line" "$pacman_conf"; then
        sudo sed -i "s/^#$line/$line/" "$pacman_conf"
        echo -e "${CAT} Uncommented: $line ${RESET}" 2>&1 | tee -a "$LOG"
    else
        echo -e "${CAT} $line is already uncommented. ${RESET}" 2>&1 | tee -a "$LOG"
    fi
done

# Add "ILoveCandy" below ParallelDownloads if it doesn't exist
if grep -q "^#ParallelDownloads" "$pacman_conf" && ! grep -q "^ILoveCandy" "$pacman_conf"; then
    sudo sed -i "/^#ParallelDownloads/a ILoveCandy" "$pacman_conf"
    echo -e "${CAT} Added ILoveCandy below ParallelDownloads. ${RESET}" 2>&1 | tee -a "$LOG"
else
    echo -e "${CAT} ILoveCandy already exists ${RESET}" 2>&1 | tee -a "$LOG"
fi

echo -e "${CAT} Pacman.conf spicing up completed ${RESET}" 2>&1 | tee -a "$LOG"

# updating pacman.conf
sudo pacman -Sy

clear