## CHANGELOGS

## Dec 2025

Added:

- `qt5-quickcontrols2` to sddm.sh - User reported w/o this SDDM crashed on login
  Fixed:
- AGS v1
  - It now does the following:
  - Clone upstream AGS 1.9.0.
  - Stub out PAM/GUtils via pam.ts.
  - Build and install AGS.
  - Install the known-good launcher from install-scripts/ags.launcher.com.github.Aylur.ags.
  - Points /usr/local/bin/ags at that launcher.
  - AGS is no longer removed when you add quickshell.
  - AGS overview is a backup if quickshell overview fails.
- meson build errors
- `rofi-wayland` package changed to 'rofi'
- Add missing monitor scripts from Fedora-Hyprland PR #234

## 22 July 2025

- Updated sddm theme and script to work with the updated simple_sddm_2 theme

## 17 July 2025

- added quickshell script to replace ags for desktop overview

## 08 June 2025

- updated SDDM theme.

## 20 March 2025

- adjusted hyprland installation script. This is great for those who are using -git packages
- added findutils as dependencies

## 11 March 2025

- Added uninstall script
- forked AGS v1 into JakooLit repo. This is just incase Aylur decide to take down v1

## 10 March 2025

- Dropped pyprland in favor of hyprland built in tool for a drop down like terminal and Desktop magnifier

## 06 March 2025

- Switched to whiptail version for Y & N questions
- switched eza to lsd

## 23 Feb 2025

- added Victor Mono Font for proper hyprlock font rendering for Dots v2.3.12
- added Fantasque Sans Mono Nerd for Kitty

## 22 Feb 2025

- replaced eog with loupe
- changed url for installing oh-my-zsh to get wider coverage. Some countries are blocking github raw url's

## 20 Feb 2025

- Added nwg-displays for the upcoming Kools dots v2.3.12

## 18 Feb 2025

- Change default zsh theme to adnosterzak
- pokemon coloscript integrated with fastfetch when opted with pokemon to add some bling
- additional external oh-my-zsh theme

## 06 Feb 2025

- added semi-unattended function.
- move all the initial questions at the beginning

## 04 Feb 2025

- Re-coded for better visibility
- Offered a new SDDM theme.
- script will automatically detect if you have nvidia but script still offer if you want to set up for user

## 29 Jan 2025

- enhanced nvidia.sh to add additional systemd-bootloader entries for nvidia

## 16 Jan 2025

- updated nvidia.sh to install non-git libva-nvidia-driver

## 13 Jan 2025

- replaced polkit-gnome with hyprpolkitagent

## 12 Jan 2025

- switch to final version of aylurs-gtk-shell-v1

## 11 Jan 2025

- added cachyos-hyprland-settings to uninstall

## 06 Jan 2025

- added copying of modified fastfetch-compact for Arch
- default theme for oh my zsh theme is now "funky"

## 26 Dec 2024

- Removal of Bibata Ice cursor on assets since its integrated in the GTK Themes and Icons extract from a separate repo
- integrated hyprcursor in Bibata Ice Cursor

## 15 Nov 2024

- revert Aylurs GTK Shell (AGS) to install older version
- added aylurs-gtk-shell to uninstall

## 20 Sep 2024

- User will be ask if they want to set Thunar as default file manager if they decided to install it

## 19 Sep 2024

- Added fastfetch on tty. However, will be disabled if user decided to install pokemon colorscripts

## 18 Sep 2024

- dotfiles will now be downloaded from main or master branch instead of from the releases version.

## 14 Sep 2024

- remove the final error checks instead, introduced a final check of essential packages to ran Hyprland

## 08 Sep 2024

- Added final error checks on install-logs

## 07 Sep 2024

- added pulseaudio check
- added sof-firmware

## 29 Aug 2024

- switched over to non-git wallust package
- improved indentions on some install scripts

## 28 Aug 2024

- Added final check if hyprland is installed and will give an error to user

## 26 Aug 2024

- Set to uninstall rofi as conflicts with rofi-wayland
- added nvidia_drm.fbdev=1 for grub

## 14 Aug 2024

- added archlinux-keyring on base.sh

## 08 Aug 2024

- Increased to 1 sec delay for installing base-devel [commit](https://github.com/JaKooLit/Arch-Hyprland/commit/7ebfa06c3b186f9bec0bcf268fae401ba67dfc2a)

## 07 Jul 2024

- added eza (ls replacement for tty). Note only on .zshrc

## 25 Jun 2024

- added fbdev=1 for nvidia.sh on `/etc/modprobe.d/nvidia.conf`. see here `https://wiki.hyprland.org/Nvidia/#drm-kernel-mode-setting`

## 26 May 2024

- Added fzf for zsh (CTRL R to invoke FZF history)

## 23 May 2024

- added qalculate-gtk to work with rofi-calc. Default keybinds (SUPER ALT C)
- added power-profiles-daemon for ROG laptops. Note, I cant add to all since it conflicts with TLP, CPU-Auto-frequency etc.
- added fastfetch

## 22 May 2024

- nwg-look is now in extra repo so replaced with nwg-look from nwg-look-bin
- change the sddm theme destination to /etc/sddm.conf.d/10-theme.conf to theme.conf.user

## 19 May 2024

- Disabled the auto-login in .zprofile as it causes auto-login to Hyprland if any wayland was chosen. Can enabled if only using hyprland

## 10 May 2024

- added wallust-git and remove python-pywal for migration to wallust on Hyprland-Dots v2.2.11

## 08 May 2024

- Adjusted sddm.sh since it does not respect preset.sh
- install.sh have been rearranged so it quits if user choose not to proceed

## 07 May 2024

- Minor typo change on nvidia.sh
- switch back to cava since installing cava-git keep it hanging (see known-issue on readme)

## 05 May 2024

- switched to rofi-wayland Extra Repo

## 04 May 2024

- separated fonts installation script for easy debugging

## 03 May 2024

- added python3-pyquery for new weather-waybar python based on Hyprland-Dots

## 02 May 2024

- Added pyprland (hyprland plugin)

## 26 Apr 2024

- Updated sddm.sh for Qt6 variant

## 23 Apr 2024

- Dropping swayidle and swaylock in favor of hypridle and hyprlock

## 20 Apr 2024

- Change default Oh-my-zsh theme to xiong-chiamiov-plus

## 16 Mar 2024

- added hyprcursor

## 1 Mar 2024

- replaced sddm-git with sddm

## 11 Jan 2024

- dropped wlsunset

## 05 Jan 2024

- Added a preset feature
- Added templates for contributing, and reporting, etc

## 01 Jan 2024

- Re-coded complete and test
- Added to spice up pacman.conf including adding of ILoveCandy on it :)

## 30 Dec 2023

- Install scripts reconstructed

## 29 December 2023

- Remove dunst in favor of swaync. NOTE: Part of the script is to also uninstall mako and dunst (if installed) as on my experience, dunst is sometimes taking over the notification even if it is not set to start

## 16 Dec 2023

- zsh theme switched to `agnoster` theme by default
- pywal tty color change disabled by default

## 13 Dec 2023

- switched hyprland to Extra Repo hyprland (both nvidia and non-nvidia). Seeing they are updating all the time :)

## 11 Dec 2023

- Changing over to zsh automatically if user opted
- If chose to install zsh and have no login manager, zsh auto login will auto start Hyprland
- added as optional, with zsh, pokemon colorscripts
- improved zsh install scripts, so even the existing zsh users of can still opt for zsh and oh-my-zsh installation :)

## 03 Dec 2023

- Added kvantum for qt apps theming
- return of wlogout due to theming issues of rofi-power

## 01 Dec 2023

- Added pipewire to install

## 30 Nov 2023

- switched to swaylock-effects-git as non-git does not seem to work

## 29 Nov 2023

- nvidia.sh edited to remove hyprland-nvidia-git as well

## 26 Nov 2023

- nvidia - Move to hyprland-git. see [`commit`](https://github.com/hyprwm/Hyprland/commit/cd96ceecc551c25631783499bd92c6662c5d3616)

## 25 Nov 2023

- drop wlogout since Hyprland-Dots v2.1.9 uses rofi-power

## 23-Nov-2023

- Added Bibata cursor to install if opted for GTK Themes. However, it is not pre-applied. Use nwg-look utility to apply

## 19-Nov-2023

- Adjust dotfiles script to download from releases instead of from upstream
