#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# zsh and oh my zsh including pokemon-color-scripts#

if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

zsh=(
    eza
    zsh
    zsh-completions
    fzf
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_zsh.log"

## Optional Pokemon color scripts
while true; do
    if [[ -z $pokemon_choice ]]; then
       read -p "${CAT} OPTIONAL - Do you want to add Pokemon color scripts? (y/n): " pokemon_choice
    fi
    case "$pokemon_choice" in
        [Yy]*)
            zsh+=('pokemon-colorscripts-git')
            sed -i '/#pokemon-colorscripts --no-title -s -r/s/^#//' assets/.zshrc >> "$LOG" 2>&1

			# commenting out fastfetch since pokemon was chosen to install
            sed -i '/^fastfetch -c $HOME\/.config\/fastfetch\/config-compact.jsonc/s/^/#/' assets/.zshrc >> "$LOG" 2>&1
			
            break
            ;;
        [Nn]*)
            echo "${NOTE}Skipping Pokemon color scripts installation.${RESET}" 2>&1 | tee -a "$LOG"
            break
            ;;
        *)
            echo "${WARN}Please enter 'y' for yes or 'n' for no.${RESET}"
            ;;
    esac
done

# Installing zsh packages
printf "${NOTE} Installing core zsh packages...${RESET}\n"
for ZSH in "${zsh[@]}"; do
  (
    # Call the global install_package function and redirect its output to the log
    install_package "$ZSH" "$LOG"
    if [ $? -ne 0 ]; then
       echo -e "\e[1A\e[K${ERROR} - $ZSH Package installation failed, Please check the installation logs"
    fi
  ) &
done
wait  # Ensure all background processes finish before continuing

# Install Oh My Zsh, plugins, and set zsh as default shell
if command -v zsh >/dev/null; then
  printf "${NOTE} Installing Oh My Zsh and plugins...\n"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
      sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
  else
      echo "Directory .oh-my-zsh already exists. Skipping re-installation." 2>&1 | tee -a "$LOG"
  fi
  # Check if the directories exist before cloning the repositories
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
  else
      echo "Directory zsh-autosuggestions already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
  else
      echo "Directory zsh-syntax-highlighting already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
  fi
  
  # Check if ~/.zshrc and .zprofile exists, create a backup, and copy the new configuration
  if [ -f "$HOME/.zshrc" ]; then
      cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup" || true
  fi

  if [ -f "$HOME/.zprofile" ]; then
      cp -b "$HOME/.zprofile" "$HOME/.zprofile-backup" || true
  fi
  
  # Copying the preconfigured zsh themes and profile
  cp -r 'assets/.zshrc' ~/
  cp -r 'assets/.zprofile' ~/

  printf "${NOTE} Changing default shell to zsh...\n"

  while ! chsh -s $(which zsh); do
      echo "${ERROR} Authentication failed. Please enter the correct password." 2>&1 | tee -a "$LOG"
      sleep 1
  done
  printf "${NOTE} Shell changed successfully to zsh.\n" 2>&1 | tee -a "$LOG"

fi

printf "\n%.0s" {1..2}
