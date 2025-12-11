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

# Fail early and make pipelines fail if any command fails
set -eo pipefail

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_ags.log"
MLOG="install-$(date +%d-%H%M%S)_ags2.log"

# NOTE: We intentionally do NOT run `ags -v` here, because a broken AGS
# installation (missing GUtils, etc.) would crash gjs and spam errors
# during install. We always (re)install v1.9.0 when this script is run.
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
# Clone repository with the specified tag and compile AGS
if git clone --depth=1 https://github.com/JaKooLit/ags_v1.9.0.git; then
    cd ags_v1.9.0 || exit 1

    # Patch tsconfig to avoid TS5107 failure (moduleResolution=node10 deprecation)
    if [ -f tsconfig.json ]; then
        # 1) Ensure ignoreDeprecations is present
        if ! grep -q '"ignoreDeprecations"[[:space:]]*:' tsconfig.json; then
            sed -i 's/"compilerOptions":[[:space:]]*{/"compilerOptions": {\n    "ignoreDeprecations": "6.0",/' tsconfig.json
        fi
        # 2) Bump moduleResolution from node10 to node16 if present
        if grep -q '"moduleResolution"[[:space:]]*:[[:space:]]*"node10"' tsconfig.json; then
            sed -i 's/"moduleResolution"[[:space:]]*:[[:space:]]*"node10"/"moduleResolution": "node16"/' tsconfig.json || true
        fi
        # 3) Fallback with Node to rewrite JSON if sed failed to catch patterns
        if grep -q '"moduleResolution"[[:space:]]*:[[:space:]]*"node10"' tsconfig.json; then
            if command -v node >/dev/null 2>&1; then
                node -e '\n                const fs = require("fs");\n                const p = "tsconfig.json";\n                const j = JSON.parse(fs.readFileSync(p, "utf8"));\n                j.compilerOptions = j.compilerOptions || {};\n                if (j.compilerOptions.moduleResolution === "node10") j.compilerOptions.moduleResolution = "node16";\n                if (j.compilerOptions.ignoreDeprecations === undefined) j.compilerOptions.ignoreDeprecations = "6.0";\n                fs.writeFileSync(p, JSON.stringify(j, null, 2));\n                '
            fi
        fi
        # Log what we ended up with for troubleshooting
        echo "== tsconfig.json after patch ==" >> "$MLOG"
        grep -n 'moduleResolution\|ignoreDeprecations' tsconfig.json >> "$MLOG" || true
    fi

    # Replace pam.ts with a stub that does NOT depend on GUtils at all.
    # The desktop overview does not use PAM, and GUtils typelib support is
    # inconsistent across distros, so we disable these helpers instead of
    # crashing at startup when the typelib is missing.
    if [ -f src/utils/pam.ts ]; then
        printf "%s Replacing src/utils/pam.ts with PAM stub (no GUtils dependency)...\\n" "${NOTE}" | tee -a "$MLOG"
        cat > src/utils/pam.ts <<'PAM_STUB'
// Stubbed PAM auth for AGS installed via Arch-Hyprland.
// The desktop overview does not use PAM, and GUtils typelib support
// is unreliable across distros, so we disable these helpers here.

export function authenticate(password: string): Promise<number> {
    return Promise.reject(new Error("PAM authentication disabled on this system (no GUtils)"));
}

export function authenticateUser(username: string, password: string): Promise<number> {
    return Promise.reject(new Error("PAM authentication disabled on this system (no GUtils)"));
}
PAM_STUB
    fi

    npm install
    meson setup build
    if sudo meson install -C build 2>&1 | tee -a "$MLOG"; then
        printf "\n${OK} ${YELLOW}Aylur's GTK shell $ags_tag${RESET} installed successfully.\n" 2>&1 | tee -a "$MLOG"
    else
        echo -e "\n${ERROR} ${YELLOW}Aylur's GTK shell $ags_tag${RESET} Installation failed\n " 2>&1 | tee -a "$MLOG"
        # Abort here on build/install failure so we do NOT install a broken launcher
        # or report success when AGS binaries are missing.
        mv "$MLOG" ../Install-Logs/ || true
        cd ..
        exit 1
    fi

    LAUNCHER_DIR="/usr/local/share/com.github.Aylur.ags"
    LAUNCHER_PATH="$LAUNCHER_DIR/com.github.Aylur.ags"
    sudo mkdir -p "$LAUNCHER_DIR"

    # Install the known-good launcher we captured from a working system.
    # This JS entry script uses GLib to set GI_TYPELIB_PATH and does not
    # depend on GIRepository, which avoids missing-typelib crashes.
    LAUNCHER_SRC="$SCRIPT_DIR/ags.launcher.com.github.Aylur.ags"
    if [ -f "$LAUNCHER_SRC" ]; then
        sudo install -m 755 "$LAUNCHER_SRC" "$LAUNCHER_PATH"
    else
        printf "${WARN} Saved launcher not found at %s; leaving Meson-installed launcher untouched.\\n" "$LAUNCHER_SRC" | tee -a "$MLOG"
    fi

    # Ensure /usr/local/bin/ags points to the JS entry script.
    sudo mkdir -p /usr/local/bin
    sudo ln -srf "$LAUNCHER_PATH" /usr/local/bin/ags
    printf "${OK} AGS launcher installed.\\n"
    # Move logs to Install-Logs directory
    mv "$MLOG" ../Install-Logs/ || true
    cd ..
else
    echo -e "\n${ERROR} Failed to download ${YELLOW}Aylur's GTK shell $ags_tag${RESET} Please check your connection\n" 2>&1 | tee -a "$LOG"
    mv "$MLOG" ../Install-Logs/ || true
    exit 1
fi

printf "\n%.0s" {1..2}
