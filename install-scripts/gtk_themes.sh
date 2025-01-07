#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# GTK Themes & ICONS and  Sourcing from a different Repo #

engine=(
    unzip
    gtk-engine-murrine
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_themes.log"


# installing engine needed for gtk themes
for PKG1 in "${engine[@]}"; do
    install_package "$PKG1" 2>&1 | tee -a "$LOG"
    if [ $? -ne 0 ]; then
        echo -e "\033[1A\033[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
        exit 1
    fi
done

# Check if the directory exists and delete it if present
if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE GTK themes and Icons folder exist..deleting..." 2>&1 | tee -a "$LOG"
    rm -rf "GTK-themes-icons" 2>&1 | tee -a "$LOG"
fi

echo "$NOTE Cloning GTK themes and Icons repository..." 2>&1 | tee -a "$LOG"
if git clone --depth 1 https://github.com/JaKooLit/GTK-themes-icons.git ; then
    cd GTK-themes-icons
    chmod +x auto-extract.sh
    ./auto-extract.sh
    cd ..
    echo "$OK Extracted GTK Themes & Icons to ~/.icons & ~/.themes folders" 2>&1 | tee -a "$LOG"
else
    echo "$ERROR Download failed for GTK themes and Icons.." 2>&1 | tee -a "$LOG"
fi

clear