#!/bin/bash
# https://github.com/JaKooLit

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "$ERROR This script should not be executed as root! Exiting......."
    exit 1
fi

clear

# Check if PulseAudio package is installed
if pacman -Qq | grep -qw '^pulseaudio$'; then
    echo "$ERROR PulseAudio is detected as installed. Uninstall it first or edit install.sh on line 211 (execute_script 'pipewire.sh')."
    exit 1
fi

# Check if base-devel is installed
if pacman -Q base-devel &> /dev/null; then
    echo "base-devel is already installed."
else
    echo "$NOTE Install base-devel.........."

    if sudo pacman -S --noconfirm --needed base-devel; then
        echo "$OK base-devel has been installed successfully."
    else
        echo "$ERROR base-devel not found nor cannot be installed."
        echo "$ACTION Please install base-devel manually before running this script... Exiting"
        exit 1
    fi
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

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
	printf "\n%.0s" {1..2}
    exit 1
fi

printf "\n%.0s" {1..2}

echo "$(tput bold)$(tput setaf 166)ATTENTION: Choosing Y on use preset question will install also nvidia stuff! $(tput sgr0)"
echo "$(tput bold)$(tput setaf 3)CTRL C to cancel and edit the file preset.sh $(tput sgr0)"  
echo "$(tput bold)$(tput setaf 7)If you are not sure what to do, answer N in here $(tput sgr0)"
read -p "$(tput setaf 6)Would you like to Use Preset Settings (See note above)? (y/n): $(tput sgr0)" use_preset

# Use of Preset Settings
if [[ $use_preset = [Yy] ]]; then
  source ./preset.sh
fi

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

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

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
ask_yes_no "-Install & configure SDDM log-in Manager plus (OPTIONAL) SDDM Theme?" sddm
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
sleep 1
# Ensuring base-devel is installed
execute_script "00-base.sh"
sleep 1
execute_script "pacman.sh"
sleep 1
# Execute AUR helper script based on user choice
if [ "$aur_helper" == "paru" ]; then
    execute_script "paru.sh"
elif [ "$aur_helper" == "yay" ]; then
    execute_script "yay.sh"
fi

# Install hyprland packages
execute_script "01-hypr-pkgs.sh"

# Install pipewire and pipewire-audio
execute_script "pipewire.sh"

# Install necessary fonts
execute_script "fonts.sh"

# Install hyprland
execute_script "hyprland.sh"

if [ "$nvidia" == "Y" ]; then
    execute_script "nvidia.sh"
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
    execute_script "dotfiles-main.sh"

fi

clear

# final check essential packages if it is installed
execute_script "02-Final-Check.sh"

printf "\n%.0s" {1..1}

# Check if hyprland or hyprland-git is installed
if pacman -Q hyprland &> /dev/null || pacman -Q hyprland-git &> /dev/null; then
    printf "\n${OK} Hyprland is installed. However, some essential packages may not be installed Please see above!"
    printf "\n${CAT} Ignore this message if it states 'All essential packages are installed.'\n"
    sleep 2
    printf "\n${NOTE} You can start Hyprland by typing 'Hyprland' (IF SDDM is not installed) (note the capital H!).\n"
    printf "\n${NOTE} However, it is highly recommended to reboot your system.\n\n"

    # Prompt user to reboot
    read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

    # Check if the user answered 'y' or 'Y'
    if [[ "$HYP" =~ ^[Yy]$ ]]; then
        if [[ "$nvidia" == "Y" ]]; then
            echo "${NOTE} NVIDIA GPU detected. Rebooting the system..."
        fi
        systemctl reboot
    fi
else
    # Print error message if neither package is installed
    printf "\n${WARN} Hyprland failed to install. Please check 00_CHECK-time_installed.log and other files Install-Logs/ directory...\n\n"
    exit 1
fi

