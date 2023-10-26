#!/bin/bash

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
LOG="install-$(date +%d-%H%M%S)_themes.log"

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
LOG="install-$(date +%d-%H%M%S)_themes.log"


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


# Themes and cursors
printf "\n${NOTE} INSTALLING GTK THEMES \n"
  while true; do
    read -rp "${CAT} Which GTK Theme and Cursors to install? Catppuccin or Tokyo Theme? Enter 'c' or 't': " choice
    case "$choice" in
      c|C)
        printf "${NOTE} Installing Catpuccin Theme packages...\n"
        for THEME1 in catppuccin-gtk-theme-mocha catppuccin-gtk-theme-latte catppuccin-cursors-mocha; do
          install_package "$THEME1" 2>&1 | tee -a "$LOG"
          [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $THEME1 install had failed, please check the install.log"; exit 1; }
        done
        # Shiny-Dark-Icons-themes
        mkdir -p ~/.icons
        cd assets
        tar -xf Shiny-Dark-Icons.tar.gz -C ~/.icons
        tar -xf Shiny-Light-Icons.tar.gz -C ~/.icons
        cd ..
        sed -i '9,12s/#//' config/hypr/scripts/DarkLight.sh
        sed -i '9,12s/#//' config/hypr/scripts/DarkLight-swaybg.sh
        sed -i '31s/#//' config/hypr/configs/Settings.conf
        cp -f 'config/hypr/waybar/style/dark-styles/style-dark-cat.css' 'config/hypr/waybar/style/style-dark.css'
        break
        ;;
      t|T)
        printf "${NOTE} Installing Tokyo Theme packages...\n"
        wget https://github.com/ljmill/tokyo-night-icons/releases/download/v0.2.0/TokyoNight-SE.tar.bz2
        mkdir -p ~/.icons
        tar -xvjf TokyoNight-SE.tar.bz2 -C ~/.icons
        mkdir -p ~/.themes
        cp -r -f assets/tokyo-themes/* ~/.themes/
        sed -i '15,18s/#//' config/hypr/scripts/DarkLight.sh
        sed -i '15,18s/#//' config/hypr/scripts/DarkLight-swaybg.sh
        sed -i '32s/#//' config/hypr/configs/Settings.conf
        cp -f 'config/hypr/waybar/style/dark-styles/style-dark-tokyo.css' 'config/hypr/waybar/style/style-dark.css'
        break
        ;;
      *)
        printf "%s - Invalid choice. Please enter 'c' or 't'\n" "${ERROR}"
        continue
        ;;
    esac
  done

  clear