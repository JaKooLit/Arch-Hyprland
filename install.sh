#!/bin/bash
# https://github.com/JaKooLit

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

clear

printf "\n%.0s" {1..3}                            
echo "   |  _.   |/  _   _  |  o _|_ "
echo " \_| (_| o |\ (_) (_) |_ |  |_ "
printf "\n%.0s" {1..2}  

# Welcome message
echo "$(tput setaf 6)Welcome to JaKooLit's Arch-Hyprland Install Script!$(tput sgr0)"
echo
echo "$(tput setaf 166)ATTENTION: Run a full system update and Reboot first!! (Highly Recommended) $(tput sgr0)"
echo
echo "$(tput setaf 3)NOTE: You will be required to answer some questions during the installation! $(tput sgr0)"
echo
echo "$(tput setaf 3)NOTE: If you are installing on a VM, ensure to enable 3D acceleration else Hyprland wont start! $(tput sgr0)"
echo

read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed
printf "\n%.0s" {1..2}
echo "$(tput bold)$(tput setaf 7)Choose Y to use preset ONLY once you reviewed, updated or updated the preset.sh $(tput sgr0)" 
echo "$(tput bold)$(tput setaf 7)If you are not sure what to do, choose N in the "Use Preset Settings" question $(tput sgr0)"
printf "\n%.0s" {1..1}
read -p "$(tput setaf 6)Would you like to Use Preset Settings? (y/n): $(tput sgr0)" use_preset

printf "\n%.0s" {1..3}

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi

if [[ $use_preset = [Yy] ]]; then
  source ./preset.sh
fi

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


# Function to colorize prompts
colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S).log"

# Initialize variables to store user responses
# aur_helper=""
# bluetooth=""
# dots=""
# gtk_themes=""
# nvidia=""
# rog=""
# sddm=""
# thunar=""
# xdph=""
# zsh=""

# Define the directory where your scripts are located
script_directory=install-scripts

# Function to ask a yes/no question and set the response in a variable
ask_yes_no() {
  if [[ ! -z "${!2}" ]]; then
    echo "$(colorize_prompt "$CAT"  "$1 (Preset): ${!2}")" 
    if [[ "${!2}" = [Yy] ]]; then
      return 0
    else
      return 1
    fi
  else
    eval "$2=''" 
  fi
    while true; do
        read -p "$(colorize_prompt "$CAT"  "$1 (y/n): ")" choice
        case "$choice" in
            [Yy]* ) eval "$2='Y'"; return 0;;
            [Nn]* ) eval "$2='N'"; return 1;;
            * ) echo "Please answer with y or n.";;
        esac
    done
}

# Function to ask a custom question with specific options and set the response in a variable
ask_custom_option() {
    local prompt="$1"
    local valid_options="$2"
    local response_var="$3"

    if [[ ! -z "${!3}" ]]; then
      return 0
    else
     eval "$3=''" 
    fi

    while true; do
        read -p "$(colorize_prompt "$CAT"  "$prompt ($valid_options): ")" choice
        if [[ " $valid_options " == *" $choice "* ]]; then
            eval "$response_var='$choice'"
            return 0
        else
            echo "Please choose one of the provided options: $valid_options"
        fi
    done
}
# Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            env USE_PRESET=$use_preset  "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}

# Collect user responses to all questions
printf "\n"
ask_custom_option "-Type AUR helper" "paru or yay" aur_helper
printf "\n"
ask_yes_no "-Do you have any nvidia gpu in your system?" nvidia
printf "\n"
ask_yes_no "-Install GTK themes (required for Dark/Light function)?" gtk_themes
printf "\n"
ask_yes_no "-Do you want to configure Bluetooth?" bluetooth
printf "\n"
ask_yes_no "-Do you want to install Thunar file manager?" thunar
printf "\n"
ask_yes_no "-Install XDG-DESKTOP-PORTAL-HYPRLAND? (For proper Screen Share ie OBS)" xdph
printf "\n"
ask_yes_no "-Install zsh, oh-my-zsh & (Optional) pokemon-colorscripts?" zsh
printf "\n"
ask_yes_no "-Installing in a Asus ROG Laptops?" rog
printf "\n"
ask_yes_no "-Do you want to download pre-configured Hyprland dotfiles?" dots
printf "\n"

# Ensuring all in the scripts folder are made executable
chmod +x install-scripts/*

# Ensuring base-devel is installed
execute_script "00-base.sh"

# Execute AUR helper script based on user choice
if [ "$aur_helper" == "paru" ]; then
    execute_script "paru.sh"
elif [ "$aur_helper" == "yay" ]; then
    execute_script "yay.sh"
fi

# Install hyprland packages
execute_script "00-hypr-pkgs.sh"

# Install pipewire and pipewire-audio
execute_script "pipewire.sh"

if [ "$nvidia" == "Y" ]; then
    execute_script "nvidia.sh"
fi

if [ "$nvidia" == "N" ]; then
    execute_script "hyprland.sh"
fi

if [ "$gtk_themes" == "Y" ]; then
    execute_script "gtk_themes.sh"
fi

if [ "$bluetooth" == "Y" ]; then
    execute_script "bluetooth.sh"
fi

if [ "$thunar" == "Y" ]; then
    execute_script "thunar.sh"
fi

if [ "$sddm" == "Y" ]; then
    execute_script "sddm.sh"
fi

if [ "$xdph" == "Y" ]; then
    execute_script "xdph.sh"
fi

if [ "$zsh" == "Y" ]; then
    execute_script "zsh.sh"
fi

execute_script "InputGroup.sh"

if [ "$rog" == "Y" ]; then
    execute_script "rog.sh"
fi

if [ "$dots" == "Y" ]; then
    execute_script "dotfiles.sh"

fi


printf "\n${OK} Yey! Installation Completed.\n"
printf "\n"
sleep 2
printf "\n${NOTE} You can start Hyprland by typing Hyprland (IF SDDM is not installed) (note the capital H!).\n"
printf "\n"
printf "\n${NOTE} It is highly recommended to reboot your system.\n\n"

read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

if [[ "$HYP" =~ ^[Yy]$ ]]; then
    if [[ "$nvidia" == "Y" ]]; then
        echo "${NOTE} NVIDIA GPU detected. Rebooting the system..."
        systemctl reboot
    else
        systemctl reboot
    fi    
fi

