#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Aylur's GTK Shell v 1.9.0 #
# for desktop overview

if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

ags=(
    typescript
    npm
    meson
    glib2-devel
    gjs 
    gtk3 
    gtk-layer-shell 
    upower
    networkmanager 
    gobject-introspection 
    libdbusmenu-gtk3 
    libsoup3
)

# specific tags to download
ags_tag="v1.9.0"

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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_ags.log"
MLOG="install-$(date +%d-%H%M%S)_ags2.log"

# Check if AGS is installed
if command -v ags &>/dev/null; then
    AGS_VERSION=$(ags -v | awk '{print $NF}') 
    if [[ "$AGS_VERSION" == "1.9.0" ]]; then
        printf "${INFO} ${MAGENTA}Aylur's GTK Shell v1.9.0${RESET} is already installed. Skipping installation."
        printf "\n%.0s" {1..2}
        exit 0
    fi
fi

# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}Aylur's GTK shell $ags_tag${RESET} Dependencies \n" "${NOTE}"

# Installing ags Dependencies
for PKG1 in "${ags[@]}"; do
    install_package "$PKG1" "$LOG"
done

printf "\n%.0s" {1..1}

# ags v1
printf "${NOTE} Install and Compiling ${SKY_BLUE}Aylur's GTK shell $ags_tag${RESET}..\n"

# Check if directory exists and remove it
if [ -d "ags_v1.9.0" ]; then
    printf "${NOTE} Removing existing ags directory...\n"
    rm -rf "ags_v1.9.0"
fi

printf "\n%.0s" {1..1}
printf "${INFO} Kindly Standby...cloning and compiling ${SKY_BLUE}Aylur's GTK shell $ags_tag${RESET}...\n"
printf "\n%.0s" {1..1}
# Clone repository with the specified tag and capture git output into MLOG
if git clone --depth=1 https://github.com/JaKooLit/ags_v1.9.0.git; then
    cd ags_v1.9.0 || exit 1
    npm install
    meson setup build
   if sudo meson install -C build 2>&1 | tee -a "$MLOG"; then
    printf "\n${OK} ${YELLOW}Aylur's GTK shell $ags_tag${RESET} installed successfully.\n" 2>&1 | tee -a "$MLOG"

    # Patch installed AGS launcher to ensure GI typelibs in /usr/local/lib are discoverable in GJS ESM
    printf "${NOTE} Applying AGS launcher patch for GI typelibs search path...\n"
    LAUNCHER="/usr/local/share/com.github.Aylur.ags/com.github.Aylur.ags"
    if sudo test -f "$LAUNCHER"; then
      # 1) Switch from GIRepository ESM import to GLib and drop deprecated prepend_* calls
      sudo sed -i \
        -e 's|^import GIR from "gi://GIRepository?version=2.0";$|import GLib from "gi://GLib";|' \
        -e '/GIR.Repository.prepend_search_path/d' \
        -e '/GIR.Repository.prepend_library_path/d' \
        "$LAUNCHER"

      # 2) Inject GI_TYPELIB_PATH export right after the GLib import
      sudo awk '{print} $0 ~ /^import GLib from "gi:\/\/GLib";$/ {print "const __old = GLib.getenv(\"GI_TYPELIB_PATH\");"; print "GLib.setenv(\"GI_TYPELIB_PATH\", \"/usr/local/lib\" + (__old ? \":\" + __old : \"\"), true);"}' "$LAUNCHER" | sudo tee "$LAUNCHER" >/dev/null

      printf "${OK} AGS launcher patched.\n"

      # Create an env-setting wrapper for AGS to ensure GI typelibs/libs are discoverable
      printf "${NOTE} Creating env wrapper /usr/local/bin/ags...\n"
      MAIN_JS="/usr/local/share/com.github.Aylur.ags/com.github.Aylur.ags"
      if ! sudo test -f "$MAIN_JS"; then
        MAIN_JS="/usr/share/com.github.Aylur.ags/com.github.Aylur.ags"
      fi
      sudo tee /usr/local/bin/ags >/dev/null <<WRAP
#!/usr/bin/env bash
set -euo pipefail
# Ensure GI typelibs and native libs are discoverable before gjs ESM loads
export GI_TYPELIB_PATH="/usr/local/lib64/girepository-1.0:/usr/local/lib/girepository-1.0:/usr/lib64/girepository-1.0:/usr/lib/girepository-1.0:/usr/local/lib64:/usr/local/lib:/usr/lib64/ags:/usr/lib/ags:${GI_TYPELIB_PATH:-}"
export LD_LIBRARY_PATH="/usr/local/lib64:/usr/local/lib:${LD_LIBRARY_PATH:-}"
exec /usr/bin/gjs -m "$MAIN_JS" "$@"
WRAP
      sudo chmod 0755 /usr/local/bin/ags
      printf "${OK} AGS wrapper installed at /usr/local/bin/ags\n"
    else
      printf "${WARN} Launcher not found at $LAUNCHER, skipping patch.\n"
    fi
  else
    echo -e "\n${ERROR} ${YELLOW}Aylur's GTK shell $ags_tag${RESET} Installation failed\n " 2>&1 | tee -a "$MLOG"
   fi
    # Move logs to Install-Logs directory
    mv "$MLOG" ../Install-Logs/ || true
    cd ..
else
    echo -e "\n${ERROR} Failed to download ${YELLOW}Aylur's GTK shell $ags_tag${RESET} Please check your connection\n" 2>&1 | tee -a "$LOG"
    mv "$MLOG" ../Install-Logs/ || true
    exit 1
fi

printf "\n%.0s" {1..2}
