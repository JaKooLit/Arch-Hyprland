#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"

ISAUR=$(command -v yay || command -v paru)

printf "\n%.0s" {1..2}

# List of packages to install / update
packages=(
    "aquamarine"
    "hyprutils"
    "hyprcursor"
    "hyprwayland-scanner"
    "hyprgraphics"
    "hyprlang"
    "hyprland-protocols"
    "hyprland-qt-support"
    "hyprland-qtutils"
    "hyprland"
    "hyprlock"
    "hypridle"
    "xdg-desktop-portal-hyprland"
    "hyprpolkitagent"
    "pyprland"
)

# Function that would show a progress bar to the user
show_progress() {
    while ps | grep $1 &> /dev/null; do
        echo -n "."
        sleep 1
    done
    echo -en "Done!"
}
# Installing packages
for package in "${packages[@]}"; do
    echo -n "Installing ${ORANGE}$package${RESET} ... ${BLUE}Kindly wait!${RESET} "

    # Show progress dots and installation result on a new line
    echo -n "..."
    
    # Install the package in the background and capture its PID
    $ISAUR -S --noconfirm --needed "$package" &>/dev/null &
    pid=$!
    
    # Start the progress bar in the background
    show_progress $pid
    
    # Wait for the package installation to finish
    wait $pid

    # Check the result of the installation
    if [ $? -eq 0 ]; then
        echo -e "\n${OK} ${ORANGE}$package${RESET} successfully installed."
        printf "\n%.0s" {1..1}
    else
        echo -e "\n${ERROR} Failed to install ${MAGENTA}$package${RESET}"
        printf "\n%.0s" {1..1}
    fi
done

printf "\n%.0s" {1..1}
printf "${OK} Done!! Now you NEED to ${YELLOW}EXIT${RESET} Hyprland and Re-Login! Enjoy!!!!"
printf "\n%.0s" {1..2}
