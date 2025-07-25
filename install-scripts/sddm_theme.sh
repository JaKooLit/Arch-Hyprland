#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# SDDM themes #

source_theme="https://github.com/JaKooLit/simple-sddm-2.git"
theme_name="simple_sddm_2"

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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm_theme.log"
    
# SDDM-themes
printf "${INFO} Installing ${SKY_BLUE}Additional SDDM Theme${RESET}\n"

# Check if /usr/share/sddm/themes/$theme_name exists and remove if it does
if [ -d "/usr/share/sddm/themes/$theme_name" ]; then
  sudo rm -rf "/usr/share/sddm/themes/$theme_name"
  echo -e "\e[1A\e[K${OK} - Removed existing $theme_name directory." 2>&1 | tee -a "$LOG"
fi

# Check if $theme_name directory exists in the current directory and remove if it does
if [ -d "$theme_name" ]; then
  rm -rf "$theme_name"
  echo -e "\e[1A\e[K${OK} - Removed existing $theme_name directory from the current location." 2>&1 | tee -a "$LOG"
fi

# Clone the repository
if git clone --depth=1 "$source_theme" "$theme_name"; then
  if [ ! -d "$theme_name" ]; then
    echo "${ERROR} Failed to clone the repository." | tee -a "$LOG"
  fi

  # Create themes directory if it doesn't exist
  if [ ! -d "/usr/share/sddm/themes" ]; then
    sudo mkdir -p /usr/share/sddm/themes
    echo "${OK} - Directory '/usr/share/sddm/themes' created." | tee -a "$LOG"
  fi

  # Move cloned theme to the themes directory
  sudo mv "$theme_name" "/usr/share/sddm/themes/$theme_name" 2>&1 | tee -a "$LOG"

  # setting up SDDM theme
  sddm_conf="/etc/sddm.conf"
  BACKUP_SUFFIX=".bak"

  echo -e "${NOTE} Setting up the login screen." | tee -a "$LOG"

  # Backup the sddm.conf file if it exists
  if [ -f "$sddm_conf" ]; then
    echo "Backing up $sddm_conf" | tee -a "$LOG"
    sudo cp "$sddm_conf" "$sddm_conf$BACKUP_SUFFIX" 2>&1 | tee -a "$LOG"
  else
    echo "$sddm_conf does not exist, creating a new one." | tee -a "$LOG"
    sudo touch "$sddm_conf" 2>&1 | tee -a "$LOG"
  fi

  # Check if the [Theme] section exists
  if grep -q '^\[Theme\]' "$sddm_conf"; then
    # Update the Current= line under [Theme]
    sudo sed -i "/^\[Theme\]/,/^\[/{s/^\s*Current=.*/Current=$theme_name/}" "$sddm_conf" 2>&1 | tee -a "$LOG"
    
    # If no Current= line was found and replaced, append it after the [Theme] section
    if ! grep -q '^\s*Current=' "$sddm_conf"; then
      sudo sed -i "/^\[Theme\]/a Current=$theme_name" "$sddm_conf" 2>&1 | tee -a "$LOG"
      echo "Appended Current=$theme_name under [Theme] in $sddm_conf" | tee -a "$LOG"
    else
      echo "Updated Current=$theme_name in $sddm_conf" | tee -a "$LOG"
    fi
  else
    # Append the [Theme] section at the end if it doesn't exist
    echo -e "\n[Theme]\nCurrent=$theme_name" | sudo tee -a "$sddm_conf" > /dev/null
    echo "Added [Theme] section with Current=$theme_name in $sddm_conf" | tee -a "$LOG"
  fi

  # Add [General] section with InputMethod=qtvirtualkeyboard if it doesn't exist
  if ! grep -q '^\[General\]' "$sddm_conf"; then
    echo -e "\n[General]\nInputMethod=qtvirtualkeyboard" | sudo tee -a "$sddm_conf" > /dev/null
    echo "Added [General] section with InputMethod=qtvirtualkeyboard in $sddm_conf" | tee -a "$LOG"
  else
    # Update InputMethod line if section exists
    if grep -q '^\s*InputMethod=' "$sddm_conf"; then
      sudo sed -i '/^\[General\]/,/^\[/{s/^\s*InputMethod=.*/InputMethod=qtvirtualkeyboard/}' "$sddm_conf" 2>&1 | tee -a "$LOG"
      echo "Updated InputMethod to qtvirtualkeyboard in $sddm_conf" | tee -a "$LOG"
    else
      sudo sed -i '/^\[General\]/a InputMethod=qtvirtualkeyboard' "$sddm_conf" 2>&1 | tee -a "$LOG"
      echo "Appended InputMethod=qtvirtualkeyboard under [General] in $sddm_conf" | tee -a "$LOG"
    fi
  fi

  # Replace current background from assets
  sudo cp -r assets/sddm.png "/usr/share/sddm/themes/$theme_name/Backgrounds/default" 2>&1 | tee -a "$LOG"
  sudo sed -i 's|^wallpaper=".*"|wallpaper="Backgrounds/default"|' "/usr/share/sddm/themes/$theme_name/theme.conf" 2>&1 | tee -a "$LOG"

  echo "${OK} - ${MAGENTA}Additional ${YELLOW}$theme_name SDDM Theme${RESET} successfully installed." | tee -a "$LOG"

else

  echo "${ERROR} - Failed to clone the sddm theme repository. Please check your internet connection." | tee -a "$LOG" >&2
fi

printf "\n%.0s" {1..2}