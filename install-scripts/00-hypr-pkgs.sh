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
cliphist
curl 
grim 
gvfs 
gvfs-mtp
imagemagick 
jq
kitty
kvantum
nano  
network-manager-applet 
pamixer 
pavucontrol
pipewire-alsa 
playerctl
polkit-gnome
python-requests
python-pywal 
qt5ct
qt6ct
qt6-svg
rofi-lbonn-wayland-git 
slurp 
swappy 
swayidle 
swaylock-effects-git
swaync 
swww 
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
eog
gnome-system-monitor
mousepad 
mpv
mpv-mpris 
nvtop
nwg-look-bin
pacman-contrib
vim
wlsunset
yt-dlp
)

fonts=(
adobe-source-code-pro-fonts 
noto-fonts-emoji
otf-font-awesome 
ttf-droid 
ttf-fira-code
ttf-jetbrains-mono 
ttf-jetbrains-mono-nerd 
)

# List of packages to uninstall as it conflicts with swaync or causing swaync to not function properly
uninstall=(
  dunst
  mako
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hypr-pkgs.log"

set -e

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

ISAUR=$(command -v yay || command -v paru)

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    $ISAUR -S --noconfirm "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is installed
    if $ISAUR -Q "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
      exit 1
    fi
  fi
}

# Function for uninstalling packages
uninstall_package() {
  # Checking if package is installed
  if pacman -Qi "$1" &>> /dev/null ; then
    # Package is installed
    echo -e "${NOTE} Uninstalling $1 ..."
    sudo pacman -Rns --noconfirm "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is uninstalled
    if ! pacman -Qi "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $1 was uninstalled."
    else
      # Something went wrong, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to uninstall. Please check the log."
      exit 1
    fi
  fi
}

# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${fonts[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the log"
    exit 1
  fi
done

# Checking if mako or dunst is installed
printf "\n%s - Checking if mako or dunst are installed and removing for swaync to work properly \n" "${NOTE}"
for PKG in "${uninstall[@]}"; do
  uninstall_package "$PKG" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG uninstallation had failed, please check the log"
    exit 1
  fi
done

clear

