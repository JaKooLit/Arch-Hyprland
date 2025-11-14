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
# Clone repository with the specified tag and capture git output into MLOG
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
                node -e '\n                const fs = require("fs");\n                const p = "tsconfig.json";\n                const j = JSON.parse(fs.readFileSync(p, "utf8"));\n                j.compilerOptions = j.compilerOptions || {};\n                if (j.compilerOptions.moduleResolution === "node10") j.compilerOptions.moduleResolution = "node16";\n                if (j.compilerOptions.ignoreDeprecations === undefined) j.compilerOptions.ignoreDeprecations = "6.0";\n                fs.writeFileSync(p, JSON.stringify(j, null, 2));\n                '\n            fi
        fi
        # Log what we ended up with for troubleshooting
        echo "== tsconfig.json after patch ==" >> "$MLOG"
        grep -n 'moduleResolution\|ignoreDeprecations' tsconfig.json >> "$MLOG" || true
    fi

    # Patch pam.ts to avoid ESM gi://GUtils, which fails on some GJS builds (e.g. Arch),
    # and instead use the older imports.gi API that we know works.
    if [ -f src/utils/pam.ts ]; then
        if grep -q "import GUtils from 'gi://GUtils'" src/utils/pam.ts; then
            printf "%s Patching src/utils/pam.ts to use imports.gi.GUtils...\n" "${NOTE}" | tee -a "$MLOG"
            tmp_pam="$(mktemp)"
            awk '
                NR==1 {
                    print "// Patched by install-scripts/ags.sh to avoid gi://GUtils ESM issues";
                    print "// eslint-disable-next-line @typescript-eslint/ban-ts-comment";
                    print "// @ts-ignore";
                    print "declare const imports: any;";
                }
                $0 ~ /^import GUtils from '\''gi:\/\/GUtils'\'';/ {
                    print "const GUtils = imports.gi.GUtils as any;";
                    next;
                }
                { print }
            ' src/utils/pam.ts > "$tmp_pam"
            mv "$tmp_pam" src/utils/pam.ts
        fi
    fi

    npm install
    meson setup build
    if sudo meson install -C build 2>&1 | tee -a "$MLOG"; then
        printf "\n${OK} ${YELLOW}Aylur's GTK shell $ags_tag${RESET} installed successfully.\n" 2>&1 | tee -a "$MLOG"
    else
        echo -e "\n${ERROR} ${YELLOW}Aylur's GTK shell $ags_tag${RESET} Installation failed\n " 2>&1 | tee -a "$MLOG"
    fi

    LAUNCHER_DIR="/usr/local/share/com.github.Aylur.ags"
    LAUNCHER_PATH="$LAUNCHER_DIR/com.github.Aylur.ags"
    sudo mkdir -p "$LAUNCHER_DIR"

    # Install a known-good launcher that sets GI_TYPELIB_PATH so GUtils and other
    # typelibs can be found, matching the working setup on jak-cachy.
    sudo tee "$LAUNCHER_PATH" >/dev/null <<'EOF'
#!/usr/sbin/gjs -m

import { exit, programArgs, programInvocationName } from "system";
import GLib from "gi://GLib";

GLib.setenv("GI_TYPELIB_PATH", "/usr/local/lib:/usr/lib/girepository-1.0", true);

imports.package.init({
    name: "com.github.Aylur.ags",
    version: "1.9.0",
    prefix: "/usr/local",
    libdir: "/usr/local/lib",
});

const module = await import("resource:///com/github/Aylur/ags/main.js");
const exitCode = await module.main([programInvocationName, ...programArgs]);
exit(exitCode);
EOF

    # Also install a convenience launcher in /usr/local/bin/ags as a shell wrapper
    # so GI_TYPELIB_PATH is set *before* gjs and GIRepository are initialized.
    sudo mkdir -p /usr/local/bin
    sudo tee /usr/local/bin/ags >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Start from user's home for configs that expect $HOME.
cd "$HOME" 2>/dev/null || true

# Locate AGS ESM entry
MAIN_JS="/usr/local/share/com.github.Aylur.ags/com.github.Aylur.ags"
if [ ! -f "$MAIN_JS" ]; then
  MAIN_JS="/usr/share/com.github.Aylur.ags/com.github.Aylur.ags"
fi
if [ ! -f "$MAIN_JS" ]; then
  echo "Unable to find AGS entry script (com.github.Aylur.ags) in /usr/local/share or /usr/share" >&2
  exit 1
fi

# Ensure GI typelibs and native libs are discoverable before gjs ESM loads
export GI_TYPELIB_PATH="/usr/local/lib64:/usr/local/lib:/usr/local/lib64/girepository-1.0:/usr/local/lib/girepository-1.0:/usr/lib/x86_64-linux-gnu/girepository-1.0:/usr/lib/girepository-1.0:/usr/lib64/girepository-1.0:/usr/lib64/ags:${GI_TYPELIB_PATH-}"
export LD_LIBRARY_PATH="/usr/local/lib64:/usr/local/lib:${LD_LIBRARY_PATH-}"

exec /usr/bin/gjs -m "$MAIN_JS" -- "$@"
EOF

    sudo chmod +x /usr/local/bin/ags
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
