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

for package in "${packages[@]}"; do
    $ISAUR -S --noconfirm --needed "$package"
done


printf "\n%.0s" {1..2}
printf "${OK} Done!! Now you NEED to ${YELLOW}EXIT${RESET} Hyprland and Re-Login! Enjoy!!!!"
printf "\n%.0s" {1..2}
