#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# SDDM Log-in Manager #

sddm=(
  qt6-declarative
  qt6-svg
  qt6-virtualkeyboard
  qt6-multimedia-ffmpeg
  qt5-quickcontrols2
  sddm
)

# login managers to attempt to disable
login=(
  lightdm
  gdm3
  gdm
  lxdm
  lxdm-gtk3
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || {
  echo "${ERROR} Failed to change directory to $PARENT_DIR"
  exit 1
}

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm.log"

# Flag parsing
ENABLE_SDDM_WAYLAND=0
for arg in "$@"; do
  case "$arg" in
    --enable-wayland)
      ENABLE_SDDM_WAYLAND=1
      ;;
    -h|--help)
      echo "Usage: $(basename "$0") [--enable-wayland]"
      exit 0
      ;;
    *)
      ;;
  esac
done

configure_sddm_wayland() {
  printf "${INFO} Configuring SDDM greeter for Wayland via cage...\n" | tee -a "$LOG"

  # Ensure cage is installed
  install_package "cage" "$LOG"

  # Detect greeter binary across distros
  GREETER=""
  for cand in /usr/libexec/sddm-greeter /usr/bin/sddm-greeter /usr/lib/sddm/sddm-greeter; do
    if [[ -x "$cand" ]]; then
      GREETER="$cand"
      break
    fi
  done
  if [[ -z "$GREETER" ]] && command -v sddm-greeter >/dev/null 2>&1; then
    GREETER="$(command -v sddm-greeter)"
  fi

  if [[ -z "$GREETER" ]]; then
    echo "${ERROR} Could not locate sddm-greeter binary. Leaving SDDM on defaults." | tee -a "$LOG"
    return 0
  fi

  sddm_conf="/etc/sddm.conf"
  BACKUP_SUFFIX=".bak"

  # Backup or create config
  if [ -f "$sddm_conf" ]; then
    echo "Backing up $sddm_conf" | tee -a "$LOG"
    sudo cp "$sddm_conf" "$sddm_conf$BACKUP_SUFFIX" 2>&1 | tee -a "$LOG"
  else
    echo "$sddm_conf does not exist, creating a new one." | tee -a "$LOG"
    sudo touch "$sddm_conf" 2>&1 | tee -a "$LOG"
  fi

  # [General] DisplayServer=wayland
  if grep -q '^\[General\]' "$sddm_conf"; then
    sudo sed -i '/^\[General\]/,/^\[/{s/^\s*DisplayServer=.*/DisplayServer=wayland/}' "$sddm_conf" 2>&1 | tee -a "$LOG"
    if ! grep -q '^\s*DisplayServer=' "$sddm_conf"; then
      sudo sed -i '/^\[General\]/a DisplayServer=wayland' "$sddm_conf" 2>&1 | tee -a "$LOG"
    fi
  else
    echo -e "\n[General]\nDisplayServer=wayland" | sudo tee -a "$sddm_conf" > /dev/null
  fi

  # [Wayland] CompositorCommand=cage -s -- <greeter>
  if grep -q '^\[Wayland\]' "$sddm_conf"; then
    sudo sed -i "/^\[Wayland\]/,/^\[/{s|^\s*CompositorCommand=.*|CompositorCommand=cage -s -- ${GREETER}|}" "$sddm_conf" 2>&1 | tee -a "$LOG"
    if ! grep -q '^\s*CompositorCommand=' "$sddm_conf"; then
      sudo sed -i "/^\[Wayland\]/a CompositorCommand=cage -s -- ${GREETER}" "$sddm_conf" 2>&1 | tee -a "$LOG"
    fi
  else
    echo -e "\n[Wayland]\nCompositorCommand=cage -s -- ${GREETER}" | sudo tee -a "$sddm_conf" > /dev/null
  fi

  echo "${OK} SDDM configured for Wayland greeter via cage." | tee -a "$LOG"
}

# Install SDDM and SDDM theme
printf "${NOTE} Installing sddm and dependencies........\n"
for package in "${sddm[@]}"; do
  install_package "$package" "$LOG"
done

printf "\n%.0s" {1..1}

# Check if other login managers installed and disabling its service before enabling sddm
for login_manager in "${login[@]}"; do
  if pacman -Qs "$login_manager" >/dev/null 2>&1; then
    sudo systemctl disable "$login_manager.service" >>"$LOG" 2>&1
    echo "$login_manager disabled." >>"$LOG" 2>&1
  fi
done

# Double check with systemctl
for manager in "${login[@]}"; do
  if systemctl is-active --quiet "$manager" >/dev/null 2>&1; then
    echo "$manager is active, disabling it..." >>"$LOG" 2>&1
    sudo systemctl disable "$manager" --now >>"$LOG" 2>&1
  fi
done

printf "\n%.0s" {1..1}
printf "${INFO} Activating sddm service........\n"
sudo systemctl enable sddm

wayland_sessions_dir=/usr/share/wayland-sessions
[ ! -d "$wayland_sessions_dir" ] && {
  printf "$CAT - $wayland_sessions_dir not found, creating...\n"
  sudo mkdir "$wayland_sessions_dir" 2>&1 | tee -a "$LOG"
}

# If requested, configure SDDM greeter to Wayland via cage
if [[ "$ENABLE_SDDM_WAYLAND" -eq 1 ]]; then
  configure_sddm_wayland
fi

printf "\n%.0s" {1..2}
