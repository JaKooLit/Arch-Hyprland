#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# KooL Arch-Hyprland uninstall script #

clear

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
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

printf "\n%.0s" {1..2}
echo -e "\e[35m
	╦╔═┌─┐┌─┐╦    ╦ ╦┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐
	╠╩╗│ ││ │║    ╠═╣└┬┘├─┘├┬┘│  ├─┤│││ ││ UNINSTALL
	╩ ╩└─┘└─┘╩═╝  ╩ ╩ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘ Arch Linux
\e[0m"
printf "\n%.0s" {1..1}

# Show welcome message using whiptail with Yes/No options
whiptail --title "Arch-Hyprland KooL Dots Uninstall Script" --yesno \
"Hello! This script will uninstall KooL Hyprland packages and configs.

You can choose packages and directories you want to remove.
NOTE: This will remove configs from ~/.config

WARNING: After uninstallation, your system may become unstable.

Shall we Proceed?" 20 80

if [ $? -eq 1 ]; then
    echo "$INFO uninstall process canceled."
    exit 0
fi

# Function to remove selected packages
remove_packages() {
    local selected_packages_file=$1
    while read -r package; do
        if pacman -Qi "$package" &> /dev/null; then
            echo "Removing package: $package"
            if ! sudo pacman -Rs --noconfirm "$package"; then
                echo "$ERROR Failed to remove package: $package"
            else
                echo "$OK Successfully removed package: $package"
            fi
        else
            echo "$INFO Package ${YELLOW}$package${RESET} not found. Skipping."
        fi
    done < "$selected_packages_file"
}

# Function to remove selected directories
remove_directories() {
    local selected_dirs_file=$1
    while read -r dir; do
        if [ -d "$HOME/.config/$dir" ]; then
            echo "Removing directory: $HOME/.config/$dir"
            if ! rm -rf "$HOME/.config/$dir"; then
                echo "$ERROR Failed to remove directory: $HOME/.config/$dir"
            else
                echo "$OK Successfully removed directory: $HOME/.config/$dir"
            fi
        else
            echo "$INFO Directory ${YELLOW}$HOME/.config/$dir${RESET} not found. Skipping."
        fi
    done < "$selected_dirs_file"
}

# Define the list of packages to choose from (with options_command tags)
packages=(
    "btop" "resource monitor" "off"
    "brightnessctl" "brightnessctl" "off"
    "cava" "Cross-platform Audio Visualizer" "off"
    "cliphist" "clipboard manager" "off"
    "fastfetch" "fastfetch" "off"
    "ffmpegthumbnailer" "FFmpeg Thumbnailer" "off"
    "grim" "screenshot tool" "off"
    "imagemagick" "Image manipulation tool" "off"
    "kitty" "kitty-terminal" "off"
    "kvantum" "QT apps theming" "off"
    "mousepad" "simple text editor" "off"
    "mpv" "multi-media player" "off"
    "mpv-mpris" "mpv-plugin" "off"
    "network-manager-applet" "network-manager-applet" "off"
    "nvtop" "gpu resource monitor" "off"
    "nwg-displays" "display monitor configuration app" "off"
    "nwg-look" "gtk settings app" "off"
    "pamixer" "pamixer" "off"
    "pokemon-colorscripts-git" "terminal colorscripts" "off"
    "pavucontrol" "pavucontrol" "off"
    "pipewire-alsa" "pipewire-alsa" "off"
    "playerctl" "playerctl" "off"
    "pyprland" "pyprland" "off"
    "qalculate-gtk" "calculater - QT" "off"
    "qt5ct" "qt5ct" "off"
    "qt6ct" "qt6ct" "off"
    "rofi-wayland" "rofi-wayland" "off"
    "slurp" "screenshot tool" "off"
    "swappy" "screenshot tool" "off"
    "swaync" "notification agent" "off"
    "swww" "wallpaper engine" "off"
    "thunar" "File Manager" "off"
    "thunar-archive-plugin" "Archive Plugin" "off"
    "thunar-volman" "Volume Management" "off"
    "tumbler" "Thumbnail Service" "off"
    "wallust" "color pallete generator" "off"
    "waybar" "wayland bar" "off"
    "wl-clipboard" "clipboard manager" "off"
    "wlogout" "logout menu" "off"
    "xdg-desktop-portal-hyprland" "hyprland file picker" "off"
    "yad" "dialog box" "off"
    "yt-dlp" "video downloader" "off"
    "xarchiver" "Archive Manager" "off"
    "hypridle" "hyprland idling agent" "off"
    "hyprlock" "lockscreen" "off"
    "hyprpolkitagent" "hyprland polkit agent" "off"
    "hyprland" "hyprland main package" "off"
)

# Define the list of directories to choose from (with options_command tags)
directories=(
    "ags" "AGS desktop overview configuration" "off"
    "btop" "btop configuration" "off"
    "cava" "cava configuration" "off"
    "fastfetch" "fastfetch configuration" "off"
    "hypr" "main hyprland configuration" "off"
    "kitty" "kitty terminal configuration" "off"
    "Kvantum" "Kvantum-manager configuration" "off"
    "qt5ct" "qt5ct configuration" "off"
    "qt6ct" "qt6ct configuration" "off"
    "rofi" "rofi configuration" "off"
    "swappy" "swappy (screenshot tool) configuration" "off"
    "swaync" "swaync (notification agent) configuration" "off"
    "Thunar" "Thunar file manager configuration" "off"
    "wallust" "wallust (color pallete) configuration" "off"
    "waybar" "waybar configuration" "off"
    "wlogout" "wlogout (logout menu) configuration" "off"    
)

# Loop for package selection until user selects something or cancels
while true; do
    package_choices=$(whiptail --title "Select Packages to Uninstall" --checklist \
    "Select the packages you want to remove\nNOTE: 'SPACEBAR' to select & 'TAB' key to change selection" 35 90 25 \
    "${packages[@]}" 3>&1 1>&2 2>&3)

    # Check if the user canceled the operation
    if [ $? -eq 1 ]; then
        echo "$INFO uninstall process canceled."
        exit 0
    fi

    # If no packages are selected, ask again
    if [[ -z "$package_choices" ]]; then
        echo "$NOTE No packages selected. Please select at least one package."
    else
        echo "$package_choices" | tr -d '"' | tr ' ' '\n' > /tmp/selected_packages.txt
        echo "Packages to remove: $package_choices"
        break
    fi
done

# Loop for directory selection until user selects something or cancels
while true; do
    dir_choices=$(whiptail --title "Select Directories to Remove" --checklist \
    "Select the directories you want to remove\nNOTE: This will remove configs from ~/.config\n\nNOTE: 'SPACEBAR' to select & 'TAB' key to change selection" 28 90 18 \
    "${directories[@]}" 3>&1 1>&2 2>&3)

    # Check if the user canceled the operation
    if [ $? -eq 1 ]; then
        echo "$INFO uninstall process canceled."
        exit 0
    fi

    # If no directories are selected, ask again
    if [[ -z "$dir_choices" ]]; then
        echo "$NOTE No directories selected. Please select at least one directory."
    else
        # Save each selected directory to a new line in the temporary file
        echo "$dir_choices" | tr -d '"' | tr ' ' '\n' > /tmp/selected_directories.txt
        echo "Directories to remove: $dir_choices"
        break
    fi
done

# First confirmation - Warning about potential instability
if ! whiptail --title "Warning" --yesno \
"Warning: Removing these packages and directories may cause your system to become unstable and you may not be able to recover it.\n\nAre you sure you want to proceed?" \
10 80; then
    echo "$INFO uninstall process canceled."
    exit 0
fi

# Second confirmation - Final confirmation to proceed
if ! whiptail --title "Final Confirmation" --yesno \
"Are you absolutely sure you want to remove the selected packages and directories?\n\nWARNING! This action is irreversible." \
10 80; then
    echo "$INFO uninstall process canceled."
    exit 0
fi

printf "\n%.0s" {1..1}
printf "\n%s${SKY_BLUE}Attempting to remove selected packages${RESET}\n" "${NOTE}"
MAX_ATTEMPTS=2
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    # Remove packages
    remove_packages /tmp/selected_packages.txt

    # Check if any packages still need to be removed, retry if needed
    MISSING_PACKAGE_COUNT=0
    while read -r package; do
        if pacman -Qi "$package" &> /dev/null; then
            MISSING_PACKAGE_COUNT=$((MISSING_PACKAGE_COUNT + 1))
        fi
    done < /tmp/selected_packages.txt

    if [ $MISSING_PACKAGE_COUNT -gt 0 ]; then
        ATTEMPT=$((ATTEMPT + 1))
        echo "Attempt #$ATTEMPT failed, retrying..."
    else
        break
    fi
done

printf "\n%.0s" {1..1}
printf "\n%s${SKY_BLUE}Attempting to remove locally installed packages${RESET}\n" "${NOTE}"
for file in ags pokemon-colorscripts; do
    if [ -f "/usr/local/bin/$file" ]; then
        sudo rm "/usr/local/bin/$file"
        echo "$file removed."
    fi
done

printf "\n%.0s" {1..1}
printf "\n%s${SKY_BLUE}Attempting to remove selected directories${RESET}\n" "${NOTE}"
remove_directories /tmp/selected_directories.txt

printf "\n%.0s" {1..1}
echo -e "$MAGENTA Hyprland and related components have been uninstalled.$RESET"
echo -e "$YELLOW It is recommended to reboot your system now.$RESET"
printf "\n%.0s" {1..1}