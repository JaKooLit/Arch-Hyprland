#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

# uninstalling hyprland packages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"


# List of packages to uninstall (including git versions)
packages=(
    "aquamarine"
    "aquamarine-git"
    "hyprutils"
    "hyprutils-git"
    "hyprcursor"
    "hyprcursor-git"
    "hyprwayland-scanner"
    "hyprwayland-scanner-git"
    "hyprgraphics"
    "hyprgraphics-git"
    "hyprlang"
    "hyprlang-git"
    "hyprland-protocols"
    "hyprland-protocols-git"
    "hyprland-qt-support"
    "hyprland-qt-support-git"
    "hyprland-qtutils"
    "hyprland-qtutils-git"
    "hyprland"
    "hyprland-git"
    "hyprlock"
    "hyprlock-git"
    "hypridle"
    "hypridle-git"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-hyprland-git"
    "hyprpolkitagent"
    "hyprpolkitagent-git"
)

# Function for uninstall packages
uninstall_package() {
  local pkg="$1"

  if pacman -Qi "$pkg" &>> /dev/null ; then
    echo -e "${NOTE} Uninstalling $pkg ..."
    sudo pacman -Rnsdd --noconfirm "$pkg" | grep -v "error: target not found"

    if ! pacman -Qi "$pkg" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $pkg was uninstalled."
    else
      echo -e "\e[1A\e[K${ERROR} $pkg failed to uninstall"
      return 1
    fi
  else
    echo -e "${NOTE} $pkg is not installed, skipping uninstallation."
  fi
  return 0
}

printf "\n%s - Removing Hyprland Packages including -git versions \n" "${NOTE}"

# Track failures but continue with next packages
overall_failed=0
for PKG in "${packages[@]}"; do
  uninstall_package "$PKG"
  if [ $? -ne 0 ]; then

    overall_failed=1
  fi
done

# Remove specific configuration file since on my experience, it conflicts.
# Dont worry, it will be reinstalled by either xdph non-git or git version
sudo rm -rf "/usr/share/xdg-desktop-portal/hyprland-portals.conf"

if [ $overall_failed -eq 0 ]; then
  echo -e "${OK} All specified hyprland packages have been uninstalled."
fi

printf "\n%.0s" {1..2}
