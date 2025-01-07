#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Aylur's GTK Shell v 1.8.2#

ags=(
    typescript
    npm
    meson
    glib2-devel
    gjs 
    gtk3 
    gtk-layer-shell 
    upower networkmanager 
    gobject-introspection 
    libdbusmenu-gtk3 
    libsoup3
)

# specific tags to download
ags_tag="v1.8.2"

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_ags.log"
MLOG="install-$(date +%d-%H%M%S)_ags2.log"

printf "\n%.0s" {1..1}

# Installation of main components
printf "\n%s - Installing AGS Dependencies \n" "${NOTE}"

# Installing ags Dependencies
for PKG1 in "${ags[@]}"; do
    install_package "$PKG1" 2>&1 | tee -a "$LOG"
    if [ $? -ne 0 ]; then
        echo -e "\033[1A\033[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
        exit 1
    fi
done

printf "\n%.0s" {1..1}
# ags
printf "${NOTE} Install and Compiling Aylurs GTK shell v1.8.2..\n"

# Check if folder exists and remove it
if [ -d "ags" ]; then
    printf "${NOTE} Removing existing ags folder...\n"
    rm -rf "ags"
fi

# Clone nwg-look repository with the specified tag
if git clone --recursive -b "$ags_tag" --depth 1 https://github.com/Aylur/ags.git; then
    cd ags || exit 1
    # Build and install ags
    npm install
    meson setup build
    if sudo meson install -C build 2>&1 | tee -a "$MLOG"; then
        printf "${OK} ags installed successfully.\n" 2>&1 | tee -a "$MLOG"
    else
        echo -e "${ERROR} Installation failed for ags" 2>&1 | tee -a "$MLOG"
    fi

    # Move logs to Install-Logs directory
    mv "$MLOG" ../Install-Logs/ || true
    cd ..
else
    echo -e "${ERROR} Failed to download ags Please check your connection" 2>&1 | tee -a "$LOG"
    mv "$MLOG" ../Install-Logs/ || true
    exit 1
fi

