#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Hyprland Packages #

# edit your packages desired here. 
# WARNING! If you remove packages here, dotfiles may not work properly.
# and also, ensure that packages are present in AUR and official Arch Repo

# add packages wanted here
Extra=(

)

hypr_package=( 
  #aylurs-gtk-shell
  bc
  cliphist
  curl 
  grim 
  gvfs 
  gvfs-mtp
  hyprpolkitagent
  imagemagick
  inxi 
  jq
  kitty
  kvantum
  libspng
  nano  
  network-manager-applet 
  pamixer 
  pavucontrol
  playerctl
  python-requests
  python-pyquery
  qt5ct
  qt6ct
  qt6-svg
  rofi-wayland
  slurp 
  swappy 
  swaync 
  swww
  unzip # needed later
  wallust 
  waybar
  wget
  wl-clipboard
  wlogout
  xdg-user-dirs
  xdg-utils 
  yad
)

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_2=(
  brightnessctl 
  btop
  cava
  loupe
  fastfetch
  gnome-system-monitor
  mousepad 
  mpv
  mpv-mpris 
  nvtop
  nwg-look
  nwg-displays
  pacman-contrib
  qalculate-gtk
  yt-dlp
)

# List of packages to uninstall as it conflicts some packages
uninstall=(
  aylurs-gtk-shell
  dunst
  mako
  cachyos-hyprland-settings
  rofi
  wallust-git
  rofi-lbonn-wayland
  rofi-lbonn-wayland-git
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi



# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hypr-pkgs.log"

# conflicting packages removal
overall_failed=0
printf "\n%s - ${SKY_BLUE}Removing some packages${RESET} as it conflicts with KooL's Hyprland Dots \n" "${NOTE}"
for PKG in "${uninstall[@]}"; do
  uninstall_package "$PKG" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    overall_failed=1
  fi
done

if [ $overall_failed -ne 0 ]; then
  echo -e "${ERROR} Some packages failed to uninstall. Please check the log."
fi

printf "\n%.0s" {1..1}

# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}KooL's Hyprland necessary packages${RESET} .... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${Extra[@]}"; do
  install_package "$PKG1" "$LOG"
done

printf "\n%.0s" {1..2}