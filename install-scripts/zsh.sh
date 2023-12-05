#!/bin/bash

############## WARNING DO NOT EDIT BEYOND THIS LINE if you dont know what you are doing! ######################################

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
LOG="install-$(date +%d-%H%M%S)_zsh.log"

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
# zsh and oh-my-zsh
printf "${WARN} #### IF YOU HAVE ALREADY ZSH AND OH MY ZSH, YOU SHOULD CHOOSE NO HERE #########\n"
printf "${WARN} ### --------------------------------------------------------------------########\n"
printf "${NOTE} ## CHECK OUT README FOR ADDITIONAL STEPS REQUIRED ONCE ZSH AND OH-MY-ZSH INSTALLED ##\n"
printf "\n\n"
read -rp "${CAT} OPTIONAL - Would you like to install zsh and oh-my-zsh and use as default shell? (y/n) " zsh
echo

if [[ $zsh =~ ^[Yy]$ ]]; then
  for ZSH in zsh zsh-completions; do
    install_package "$ZSH" 2>&1 | tee -a "$LOG"
    if [ $? -ne 0 ]; then
      echo -e "\e[1A\e[K${ERROR} - $ZSH install had failed, please check the install.log"
    fi
  done

  # Oh-my-zsh plus zsh-autosuggestions and zsh-syntax-highlighting
  printf "${NOTE} Installing oh-my-zsh and plugins.\n"
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  cp -r 'assets/.zshrc' ~/
else
  printf "${NOTE} ZSH wont be installed.\n"
fi

clear