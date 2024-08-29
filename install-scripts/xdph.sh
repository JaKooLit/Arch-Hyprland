#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# XDG-Desktop-Portals #
if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

xdg=(
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_xdph.log"

# XDG-DESKTOP-PORTAL-HYPRLAND
for xdgs in "${xdg[@]}"; do
  install_package "$xdgs" 2>&1 | tee -a "$LOG"
    if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $xdph Package installation failed, Please check the installation logs"
    exit 1
    fi
done

printf "\n"
    
printf "${NOTE} Checking for other XDG-Desktop-Portal-Implementations....\n"
sleep 1
printf "\n"
printf "${NOTE} XDG-desktop-portal-KDE & GNOME (if installed) should be manually disabled or removed! I can't remove it... sorry...\n"
while true; do
    if [[ -z $XDPH1 ]]; then
      read -rp "${CAT} Would you like to try to remove other XDG-Desktop-Portal-Implementations? (y/n) " XDPH1
    fi
    echo
    sleep 1

    case $XDPH1 in
        [Yy])
            # Clean out other portals
            printf "${NOTE} Clearing any other xdg-desktop-portal implementations...\n"
            # Check if packages are installed and uninstall if present
            if pacman -Qs xdg-desktop-portal-wlr > /dev/null ; then
                echo "Removing xdg-desktop-portal-wlr..."
                sudo pacman -R --noconfirm xdg-desktop-portal-wlr 2>&1 | tee -a "$LOG"
            fi
            if pacman -Qs xdg-desktop-portal-lxqt > /dev/null ; then
                echo "Removing xdg-desktop-portal-lxqt..."
                sudo pacman -R --noconfirm xdg-desktop-portal-lxqt 2>&1 | tee -a "$LOG"
            fi
            break
            ;;
        [Nn])
            echo "no other XDG-implementations will be removed." >> "$LOG"
            break
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
done

clear
