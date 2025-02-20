#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# pokemon-color-scripts#

poke=(
  mercurial
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_zsh_pokemon.log"

# for the new oh my zsh theme
printf "${NOTE} Installing ${SKY_BLUE}additional dependencies for oh my zsh theme${RESET}\n" 
for pok in "${poke[@]}"; do
  install_package "$pok" "$LOG"
done
printf "\n%.0s" {1..1}

printf "${INFO} Installing ${SKY_BLUE}Pokemon color scripts${RESET} ..."

if [ -d "pokemon-colorscripts" ]; then
    cd pokemon-colorscripts && git pull && sudo ./install.sh && cd ..
    else
    git clone --depth 1 https://gitlab.com/phoneybadger/pokemon-colorscripts.git &&
    cd pokemon-colorscripts && sudo ./install.sh && cd ..
fi

# Check if ~/.zshrc exists
if [ -f "$HOME/.zshrc" ]; then
    sed -i '/#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME\/.config\/fastfetch\/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -/s/^#//' "$HOME/.zshrc" >> "$LOG" 2>&1
    sed -i '/^fastfetch -c $HOME\/.config\/fastfetch\/config-compact.jsonc/s/^/#/' "$HOME/.zshrc" >> "$LOG" 2>&1
else
    echo "$HOME/.zshrc not found. Cant enable ${YELLOW}Pokemon color scripts${RESET}" >> "$LOG" 2>&1
fi

# copy additional oh-my-zsh themes from assets
if [ -d "$HOME/.oh-my-zsh/themes" ]; then
    cp -r assets/add_zsh_theme/* ~/.oh-my-zsh/themes >> "$LOG" 2>&1
fi
  
printf "\n%.0s" {1..2}
