#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# waybar - from source #

waybar=(
cmake
meson
scdoc
wayland-protocols
clang-tidy 
gobject-introspection 
libdbusmenu-gtk3-dev 
libevdev-dev 
libfmt-dev 
libgirepository1.0-dev 
libgtk-3-dev 
libgtkmm-3.0-dev 
libinput-dev 
libjsoncpp-dev 
libmpdclient-dev 
libnl-3-dev 
libnl-genl-3-dev 
libpulse-dev 
libsigc++-2.0-dev 
libspdlog-dev 
libwayland-dev 
scdoc 
upower 
libxkbregistry-dev
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)waybar-git.log"

# Installation of dependencies
printf "\n%s - Installing waybar-git dependencies.... \n" "${NOTE}"

for PKG1 in "${waybar[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

# Clone and build waybar from source
printf "${NOTE} Installing waybar...\n"
if git clone https://github.com/Alexays/Waybar; then
  cd Waybar || exit 1
	meson build
    if sudo ninja -C build install 2>&1 | tee -a "$LOG" ; then
        printf "${OK} waybar-git installed successfully.\n" 2>&1 | tee -a "$LOG"
    else
        echo -e "${ERROR} Installation failed for waybar-git." 2>&1 | tee -a "$LOG"
    fi
else
    echo -e "${ERROR} Download failed for waybar-git" 2>&1 | tee -a "$LOG"
fi

clear
