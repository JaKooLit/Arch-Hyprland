<div align="center">

# 💌 ** JaKooLit's Arch Hyprland Install Script ** 💌

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/Arch-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/Arch-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/Arch-Hyprland?style=for-the-badge&color=cba6f7)


<br/>
</div>

#### Hyprland-Dots-showcase 
<p align="center">
    <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Arch-v2/Arch-Default-Layout.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/dark-theme.png" />   
   <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/Light-theme.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Arch-v2/Another-Screenshot.png"" /> 
</p>

<p align="center">
    <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/default-waybar.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/rofi.png" />   
   <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/wlogout-dark.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/showcase2.png"" /> 
   <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/waybar-layout.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/waybar-style.png"" /> 
</p>


### 📷 More Screenshots on v2 [`Link`](https://github.com/JaKooLit/screenshots/tree/main/Hyprland-Dots-Showcase) and [`Previous-Screenshots`](https://github.com/JaKooLit/screenshots/tree/main/Hyprland-ScreenShots/Arch-v2) and 


### ✨ A video walk through my dotfiles[`Link`](https://youtu.be/fO-RBHvVEcc?si=ijqxxnq_DLiyO8xb)
### ✨ A video walk on My Hyprland-Dots v2[`Link`](https://youtu.be/yaVurRoXc-s?si=iDnBC5S3thPBX3ZE)

### 📽️ youtube video showcase: [`Link`](https://youtu.be/W2UFwkgdwNo)


## 🪧🪧🪧 ANNOUNCEMENT 🪧🪧🪧
- This Repo does not contain Hyprland Dots or configs! Dotfiles can be checked here [`Hyprland-Dots`](https://github.com/JaKooLit/Hyprland-Dots) . During installation, if you opt to copy installation, it will be downloaded from that centralized repo.
- Hyprland-Dots use are constantly evolving / improving. you can check CHANGELOGS here [`Hyprland-Dots-Changelogs`](https://github.com/JaKooLit/Hyprland-Dots/wiki/7.-CHANGELOGS) 
- Since the Hyprland-Dots are evolving, some of the screenshots maybe old

> [❗!IMPORTANT]
> install a backup tool like `snapper` or `timeshift`. and Backup your system before installing hyprland using this script. This script does NOT include uninstallation of packages

### 🆕  Prerequisites
- This install script is intended for atleast Server type / Minimal Arch Linux installed.

### 🔘 Pipewire and Pipewire audio
- This script will install pipewire and will also disable or will uninstall pulseaudio. If you dont want it, you can simply just delete pipewire.sh in install-scripts folder before installing. 

### ✨ Costumize the packages to be installed
- inside the install-scripts folder, you can edit 00-hypr-pkgs.sh. Care though as the Hyprland Dots may not work properly!
- default GTK theme if agreed to be installed is Tokyo night GTK themes (dark and light) + Tokyo night SE icons

### 💫 SDDM and GTK Themes offered
- If you opted to install SDDM theme, here's the [`LINK`](https://github.com/JaKooLit/simple-sddm)
- If you opted to install GTK Themes, Icons and Cursor offered are Tokyo Nights. [`LINK`](https://github.com/JaKooLit/GTK-themes-icons) & Bibata Cursor Modern Ice 

### 👀 NVidia GPU Owners.
- By default, nvidia-dkms will be installed. and only supports GTX 900 and newer. If required to install older driver, edit the nvidia.sh in scripts-folder
> [!IMPORTANT]
> If you want to use nouveau driver, choose N when asked if you have nvidia gpu. This is because the nvidia installer part, it will blacklist nouveau. Hyprland will still be installed but it will skip blacklisting nouveau.

### ✨ to run
> clone this repo by using git. Change directory, make executable and run the script
```bash
git clone https://github.com/JaKooLit/Arch-Hyprland.git
cd Arch-Hyprland
chmod +x install.sh
./install.sh
```

<p align="center">
    <img align="center" width="100%" src="https://raw.githubusercontent.com/JaKooLit/Arch-Hyprland/main/Arch-Installer.png" />

### ✨ for ZSH and OH-MY-ZSH installation
> installer should auto change your default shell to zsh. However, if it does not, do this
```bash
chsh -s $(which zsh)
zsh
source ~/.zshrc
```
- reboot or logout
- by default agnoster theme is installed. You can find more themes from this [`OH-MY-ZSH-THEMES`](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
- to change the theme, edit ~/.zshrc . Look for ZSH_THEME="desired theme"

### ✨ TO DO once installation done and dotfiles copied
- ~~if you opted to install gtk themes, to apply the theme and icon, press the dark/light button (beside the padlock). To apply Bibata modern ice cursor, launch nwg-look (GTK Settings) through rofi.~~ Hyprland-Dots v2.1.18, initial boot file will attempt to apply GTK themes,cursor, and icons. You can tweak more using nwg-look (GTK-Settings) utility

- SUPER H for HINT or click on the waybar HINT! Button 
- Head over to [FAQ](https://github.com/JaKooLit/Hyprland-Dots/wiki/4.-FAQ) and [TIPS](https://github.com/JaKooLit/Hyprland-Dots/wiki/5.-TIPS)

### 🏴‍☠️🏴‍☠️🏴‍☠️ Got a questions regarding the Hyprland Dots?
- Head over to wiki Link [`WIKI`](https://github.com/JaKooLit/Hyprland-Dots/wiki)

### 🛣️ Roadmap:
- ~~[ ] Install zsh and oh-my-zsh without necessary steps above~~ DONE 
- [ ] possibly adding gruvbox themes, cursors, icons

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

### 📒 Final Notes
- join my discord channel [`Discord`](https://discord.gg/V2SJ92vbEN)
- Feel free to copy, re-distribute, and use this script however you want. Would appreciate if you give me some loves by crediting my work :)

### 👍👍👍 Thanks and Credits!
- [`Hyprland`](https://hyprland.org/) Of course to Hyprland and @vaxerski for this awesome Dynamic Tiling Manager.

## 💖 Support
- a Star on my Github repos would be nice 🌟

- Subscribe to my Youtube Channel [YouTube](https://www.youtube.com/@Ja.KooLit) 

- You can also buy me Coffee Through ko-fi.com or Coffee.com 🤩

<a href='https://ko-fi.com/jakoolit' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/JaKooLit)

### Youtube videos (Click to view and watch the playlist)
[![Youtube Playlist Thumbnail](https://raw.githubusercontent.com/JaKooLit/screenshots/main/Youtube.png)](https://youtube.com/playlist?list=PLDtGd5Fw5_GjXCznR0BzCJJDIQSZJRbxx&si=iaNjLulFdsZ6AV-t)