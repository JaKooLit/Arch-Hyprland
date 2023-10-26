#!/bin/bash

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
LOG="install-$(date +'%d-%H%M%S')_dots.log"

printf "${NOTE} Downloading Hyprland dots...\n"

if [ -d Hyprland-Dots ]; then
  cd Hyprland-Dots
  chmod +x copy.sh
  ./copy.sh 2>&1 | tee -a "$LOG"
else
  if git clone https://github.com/JaKooLit/Hyprland-Dots.git; then
    cd Hyprland-Dots || exit 1
    chmod +x copy.sh
    ./copy.sh 2>&1 | tee -a "$LOG"
  else
    echo -e "${ERROR} Can't download Hyprland-Dots" 2>&1 | tee -a "$LOG"
  fi
fi



