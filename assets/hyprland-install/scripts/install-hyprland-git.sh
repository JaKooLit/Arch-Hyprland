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

# List of packages to install / update
packages=(
    "hyprutils-git"
    "hyprcursor-git"
    "hyprwayland-scanner-git"
    "aquamarine-git"
    "hyprgraphics-git"
    "hyprlang-git"
    "hyprland-protocols-git"
    "hyprland-qt-support-git"
    "hyprland-qtutils-git"
    "hyprland-git"
    "hyprlock-git"
    "hypridle-git"
    "xdg-desktop-portal-hyprland-git"
    "hyprpolkitagent-git"
    "pyprland"
)

# clearing cache
printf "${ACTION} Lets Clear Cache first!!!!"

sudo pacman -Scc &&
$ISAUR -Scc &&

printf "\n%.0s" {1..2}

for package in "${packages[@]}"; do
    $ISAUR -S --noconfirm --needed "$package"
done

printf "\n%.0s" {1..2}
printf "${OK} Done!! Now you NEED to ${YELLOW}EXIT${RESET} Hyprland and Re-Login! Enjoy!!!!"
printf "\n%.0s" {1..2}
