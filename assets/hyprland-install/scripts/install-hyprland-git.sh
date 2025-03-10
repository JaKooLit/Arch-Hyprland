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
)

# rotating stars progress
show_progress() {
    spin='-'
    while ps | grep $1 &> /dev/null; do
        echo -ne "\rInstalling ${ORANGE}$2${RESET} ... Kindly wait! $spin"  
        sleep 0.3
        case $spin in
            '-') spin='\';;
            '\') spin='|';;
            '|') spin='/';;
            '/') spin='-';;
        esac
    done
    echo -en "\rInstalling ${ORANGE}$2${RESET} ... Kindly wait! .... Done!"
}

# Clearing cache
echo -n "${CAT} Recommend (choose y to all) to clear ${MAGENTA}pacman and aur helper${RESET} cache ..."
printf "\n%.0s" {1..1}
sudo pacman -Scc &&
$ISAUR -Scc

printf "\n%.0s" {1..1}
printf "${NOTE} Installing ${BLUE}git hyprland version${RESET}....."
printf "\n%.0s" {1..1}

# Installing packages
for package in "${packages[@]}"; do
    $ISAUR -S --noconfirm "$package" &>/dev/null &
    pid=$!
    
    show_progress $pid $package
    
    wait $pid

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
