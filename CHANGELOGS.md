## Changelogs

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



