<div align="center">

# 💌 ** JaKooLit's Arch Hyprland Install Script ** 💌

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/Arch-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/Arch-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/Arch-Hyprland?style=for-the-badge&color=cba6f7)


<br/>
</div>

### Basically a copy of my Hyprland-v4 Hyprland-install script [`Link`](https://github.com/JaKooLit/Hyprland-v4)

<p align="center">
    <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Arch/dual-panel-light-dark-switch.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Arch/dual-panel-dark_light-switch.png" />   
   <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Arch/gnome-style.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Arch/Plasma-Style.png" />  /> 


### 📽️ youtube video showcase: [`Youtube Link`](https://youtu.be/otda1nXJ5Dg?si=Wbb8eg-u3Y-tDnDQ)



### ✨ A video walk through my dotfiles[`Link`](https://youtu.be/fO-RBHvVEcc?si=ijqxxnq_DLiyO8xb)


### 🆕  What's new?
- Basically just a clone of my Hyprland-v4. Just renamed and cleaned up codes.
- Concentrated on Tokyo Themes and Tokyo Night SE icons only
- Downloading of dot files will be a centralized repo


### 👀 NVidia GPU Owners.
- By default, nvidia-dkms will be installed. and only supports GTX 900 and newer. If required to install older driver, edit the nvidia.sh in scripts-folder


### ✨ to run
> clone this repo by using git. Change directory, make executable and run the script
```bash
git clone https://github.com/JaKooLit/Arch-Hyprland.git
cd Arch-Hyprland
chmod +x install.sh
./install.sh
```
### ✨ for ZSH and OH-MY-ZSH installation
> do this once installed and script completed; do the following to change the default shell zsh
```bash
chsh -s $(which zsh)
zsh
source ~/.zshrc
```
- reboot or logout
- by default gnzh theme is installed. You can find more themes from this [`OH-MY-ZSH-THEMES`](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
- to change the theme, edit ~/.zshrc ZSH_THEME="desired theme"

### 📒 Notes
- super h for launching a small help file
- super e to view / edit settings, monitor, keybinds, Environment Variables, etc
- go through the keybinds. There are alot of hidden features like dual panel, change waybar styles, change wallpaper, etc... its too long to put all in the readme!!!

### 🛣️ Roadmap:
- [ ] Install zsh and oh-my-zsh without necessary steps above
- [ ] possibly adding gruvbox themes, cursors, icons
- [ ] adding vertical waybar 
- [X] ~~Use kitty in favor of foot~~ - Dropped the idea of kitty. Kitty is using twice memory compared to foot.

### ⚠️ some known issues
- reports from members of my discord, states that some users of nvidia are getting stuck on sddm login. credit  to @Kenni Fix stated was 
```  
 while in sddm press ctrl+alt+F2 or F3
log into your account
`lspci -nn`, find the id of your nvidia card
`ls /dev/dri/by-path` find the matching id
`ls -l /dev/dri/by-path` to check where the symlink points to 
)
7. add "env = WLR_DRM_DEVICES,/dev/dri/cardX" to the ENVvariables config (.config/hypr/configs/ENVariables.conf)  ; X being where the symlink of the gpu points to
```
- more info from the hyprland wiki [`Hyprland Wiki Link`](https://wiki.hyprland.org/FAQ/#my-external-monitor-is-blank--doesnt-render--receives-no-signal-laptop)


### 👍👍👍 Thanks and Credits!
- shout out to CooSee from Gentoo forums for the nice rainbow borders


## 💖 Support
- a Star on my Github repos would be nice 🌟

- Subscribe to my Youtube Channel [YouTube](https://www.youtube.com/@Ja.KooLit) 

- You can also buy me Coffee Through ko-fi.com 🤩

<a href='https://ko-fi.com/jakoolit' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />