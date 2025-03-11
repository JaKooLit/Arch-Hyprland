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

# Check if the user confirmed to proceed
if [ $? -eq 1 ]; then
    echo "$INFO uninstall process canceled."
    exit 0
fi

# Function to remove selected packages
remove_packages() {
    local selected_packages=($1)
    for package in "${selected_packages[@]}"; do
        package=$(echo "$package" | tr -d '"')  
        if pacman -Qi "$package" &> /dev/null; then
            echo "Removing package: $package"
            if ! sudo pacman -Rsc --noconfirm "$package"; then
                echo "$ERROR Failed to remove package: $package"
            else
                echo "$OK Successfully removed package: $package"
            fi
        else
            echo "$INFO Package ${YELLOW}$package${RESET} not found. Skipping."
        fi
    done
}

# Function to remove selected directories
remove_directories() {
    local selected_dirs=($1)
    for dir in "${selected_dirs[@]}"; do
        dir=$(echo "$dir" | tr -d '"') 
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
    done
}

# Define the list of packages to choose from (with options_command tags)
packages=(
    "cliphist" "clipboard manager" "off"
    "grim" "screenshot tool" "off"
    "hyprpolkitagent" "hyprland polkit agent" "off"
    "imagemagick" "imagemagick" "off"
    "inxi" "CLI system information" "off"
    "jq" "json data" "off"
    "kitty" "kitty-terminal" "off"
    "kvantum" "QT apps theming" "off"
    "network-manager-applet" "network-manager-applet" "off"
    "pamixer" "pamixer" "off"
    "pavucontrol" "pavucontrol" "off"
    "pipewire-alsa" "pipewire-alsa" "off"
    "playerctl" "playerctl" "off"
    "qt5ct" "qt5ct" "off"
    "qt6ct" "qt6ct" "off"
    "qt6-svg" "qt6-svg" "off"
    "rofi-wayland" "rofi-wayland" "off"
    "slurp" "screenshot tool" "off"
    "swappy" "screenshot tool" "off"
    "swaync" "notification agent" "off"
    "swww" "wallpaper engine" "off"
    "unzip" "unzip" "off"
    "wallust" "color pallete generator" "off"
    "waybar" "wayland bar" "off"
    "wl-clipboard" "clipboard manager" "off"
    "wlogout" "logout menu" "off"
    "yad" "dialog box" "off"
    "brightnessctl" "brightnessctl" "off"
    "btop" "resource monitor" "off"
    "cava" "Cross-platform Audio Visualizer" "off"
    "loupe" "image viewer" "off"
    "fastfetch" "fastfetch" "off"
    "gnome-system-monitor" "gnome-system-monitor" "off"
    "mousepad" "simple text editor" "off"
    "mpv" "multi-media player" "off"
    "mpv-mpris" "mpv-plugin" "off"
    "nvtop" "gpu resource monitor" "off"
    "nwg-look" "gtk settings app" "off"
    "nwg-displays" "display monitor configuration app" "off"
    "qalculate-gtk" "calculater - QT" "off"
	"thunar" "File Manager" "off"
	"thunar-volman" "Volume Management" "off"
	"tumbler" "Thumbnail Service" "off"
	"ffmpegthumbnailer" "FFmpeg Thumbnailer" "off"
	"thunar-archive-plugin" "Archive Plugin" "off"
	"xarchiver" "Archive Manager" "off"
    "yt-dlp" "video downloader" "off"
    "xdg-desktop-portal-hyprland" "hyprland file picker" "off"
    "xdg-desktop-portal-gtk" "gtk file picker" "off"
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
        # Convert the selected package list into an array and clean up quotes
        IFS=" " read -r -a selected_packages <<< "$package_choices"
        selected_packages=($(echo "${selected_packages[@]}" | tr -d '"'))
        echo "Packages to remove: ${selected_packages[@]}"
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
        # Convert the selected directories list into an array and clean up quotes
        IFS=" " read -r -a selected_dirs <<< "$dir_choices"
        selected_dirs=($(echo "${selected_dirs[@]}" | tr -d '"'))
        echo "Directories to remove: ${selected_dirs[@]}"
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

# Start removing packages and directories
if [ ${#selected_packages[@]} -gt 0 ]; then
    remove_packages "${selected_packages[@]}"
fi

if [ ${#selected_dirs[@]} -gt 0 ]; then
    remove_directories "${selected_dirs[@]}"
fi

echo "$INFO Uninstall process completed."
