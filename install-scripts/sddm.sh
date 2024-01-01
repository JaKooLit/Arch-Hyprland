#!/bin/bash

sddm=(
  qt5-graphicaleffects
  qt5-quickcontrols2
  qt5-svg
  sddm-git
)

############## WARNING DO NOT EDIT BEYOND THIS LINE if you dont know what you are doing! ######################################

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_sddm.log"

ISAUR=$(command -v yay || command -v paru)

# Set the script to exit on error
set -e

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

# SDDM

# Check if SDDM is already installed
if pacman -Qs sddm > /dev/null; then
  # Prompt user to manually install sddm-git to remove SDDM
  read -n1 -rep "SDDM is already installed. Would you like to manually install sddm-git to remove it? This requires manual intervention. (y/n)" manual_install_sddm
  echo
  if [[ $manual_install_sddm =~ ^[Yy]$ ]]; then
    $ISAUR -S sddm-git 2>&1 | tee -a "$LOG"
  fi
fi

# Install SDDM and SDDM theme
printf "${NOTE} Installing SDDM-git and dependencies........\n"
  for package in "${sddm[@]}"; do
  install_package "$package" 2>&1 | tee -a "$LOG"
  [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $package install has failed, please check the install.log"; exit 1; }
 done 

# Check if other login managers installed and disabling its service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if pacman -Qs "$login_manager" > /dev/null; then
    echo "disabling $login_manager..."
    sudo systemctl disable "$login_manager.service" 2>&1 | tee -a "$LOG"
  fi
done

printf " Activating sddm service........\n"
sudo systemctl enable sddm

# Set up SDDM
echo -e "${NOTE} Setting up the login screen."
sddm_conf_dir=/etc/sddm.conf.d
[ ! -d "$sddm_conf_dir" ] && { printf "$CAT - $sddm_conf_dir not found, creating...\n"; sudo mkdir "$sddm_conf_dir" 2>&1 | tee -a "$LOG"; }

wayland_sessions_dir=/usr/share/wayland-sessions
[ ! -d "$wayland_sessions_dir" ] && { printf "$CAT - $wayland_sessions_dir not found, creating...\n"; sudo mkdir "$wayland_sessions_dir" 2>&1 | tee -a "$LOG"; }
sudo cp assets/hyprland.desktop "$wayland_sessions_dir/" 2>&1 | tee -a "$LOG"
    
# SDDM-themes
valid_input=false
while [ "$valid_input" != true ]; do
  read -n 1 -r -p "${CAT} OPTIONAL - Would you like to install SDDM themes? (y/n)" install_sddm_theme
  if [[ $install_sddm_theme =~ ^[Yy]$ ]]; then
    printf "\n%s - Installing Simple SDDM Theme\n" "${NOTE}"

    # Check if /usr/share/sddm/themes/simple-sddm exists and remove if it does
    if [ -d "/usr/share/sddm/themes/simple-sddm" ]; then
      sudo rm -rf "/usr/share/sddm/themes/simple-sddm"
      echo -e "\e[1A\e[K${OK} - Removed existing 'simple-sddm' directory." 2>&1 | tee -a "$LOG"
    fi

    # Check if simple-sddm directory exists in the current directory and remove if it does
    if [ -d "simple-sddm" ]; then
      rm -rf "simple-sddm"
      echo -e "\e[1A\e[K${OK} - Removed existing 'simple-sddm' directory from the current location." 2>&1 | tee -a "$LOG"
    fi

    if git clone https://github.com/JaKooLit/simple-sddm.git 2>&1 | tee -a "$LOG"; then
      while [ ! -d "simple-sddm" ]; do
        sleep 1
      done

      if [ ! -d "/usr/share/sddm/themes" ]; then
        sudo mkdir -p /usr/share/sddm/themes
        echo -e "\e[1A\e[K${OK} - Directory '/usr/share/sddm/themes' created." 2>&1 | tee -a "$LOG"
      fi

      sudo mv simple-sddm /usr/share/sddm/themes/
      echo -e "[Theme]\nCurrent=simple-sddm" | sudo tee "$sddm_conf_dir/10-theme.conf" &>> "$LOG"
    else
      echo -e "\e[1A\e[K${ERROR} - Failed to clone the theme repository. Please check your internet connection or repository availability." | tee -a "$LOG" >&2
    fi
    valid_input=true
  elif [[ $install_sddm_theme =~ ^[Nn]$ ]]; then
    printf "\n%s - No SDDM themes will be installed.\n" "${NOTE}" 2>&1 | tee -a "$LOG"
    valid_input=true
  else
    printf "\n%s - Invalid input. Please enter 'y' for Yes or 'n' for No.\n" "${ERROR}" 2>&1 | tee -a "$LOG"
  fi
done



clear