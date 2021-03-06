#!/bin/env bash
set -e

echo "Welcome!" && sleep 2

# aliases

# does full system update
echo "Doing a system update, cause stuff may break if it's not the latest version..."
sudo pacman --noconfirm -Syu

echo "###########################################################################"
echo "Will do stuff, get ready"
echo "###########################################################################"

# install base-devel if not installed
sudo pacman -S --noconfirm --needed base-devel wget

# refresh video driver for manjaro
sudo mhwd -a pci nonfree 0300

# install xorg if not installed
sudo pacman -S --noconfirm --needed feh xorg xorg-xinit xorg-xinput xmonad zsh

# install gtk3
sudo pacman -S --noconfirm --needed gtk3

# install file manager
sudo pacman -S --noconfirm --needed pcmanfm-gtk3 gvfs

# install NetworkManager and set to startup on boot.
sudo pacman -S --noconfirm --needed networkmanager nm-connection-editor 
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# install ripgrep.
sudo pacman -S --noconfirm --needed ripgrep

# install neovim.
sudo pacman -S --noconfirm --needed neovim

# install and configure pulseaudio
sudo pacman -S --noconfirm --needed alsa-utils pulseaudio pa-applet pulseaudio-alsa pulseaudio-bluetooth manjaro-pulse

# install firefox-developer-edition
sudo pacman -S --noconfirm --needed firefox-developer-edition

# Install rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

# Install nightly rust
rustup install nightly

# Install RLS
rustup component add rls rust-analysis rust-src

# Install ripgrep
cargo install ripgrep

# Install newest eww
cargo +nightly install --git https://github.com/elkowar/eww

# fix spotify gpg key issue
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -

# install fonts, window manager and terminal
mkdir -p ~/.local/share/fonts
mkdir -p ~/.srcs

# cd ~/.srcs 

# git clone $CLIENT/$FONT 
cp -r ./fonts/* ~/.local/share/fonts/
fc-cache -f
clear 

# install paru
read -r -p "Would you like to install paru? Say no if you already have it (step necessary because well, we need some stuff) [yes/no]: " paru
# echo "Please replace libxft with libxft-bgra in next install" 
sleep 3

case $paru in
[yY][eE][sS]|[yY])
	cargo install paru

	paru -S --noconfirm --needed picom-jonaburg-git acpi rofi-git candy-icons-git wmctrl alacritty playerctl brightnessctl dunst xmonad-contrib jq xclip maim rofi-greenclip spotify betterlockscreen
	;; 

[nN][oO]|[nN])
	echo "Installing Other Stuff then"
	paru -S --noconfirm --needed picom-jonaburg-git acpi rofi-git candy-icons-git wmctrl alacritty playerctl brightnessctl dunst xmonad-contrib jq xclip maim rofi-greenclip spotify betterlockscreen
	;; 

[*])
	echo "Lets do it anyways lol" 
	paru -S --noconfirm --needed picom-jonaburg-git acpi rofi-git candy-icons-git wmctrl alacritty playerctl brightnessctl dunst xmonad-contrib jq xclip maim rofi-greenclip spotify betterlockscreen
	sleep 1
	;;
esac

## Install various themes
paru -S --needed --noconfirm gtk3 lxappearance-gtk3 adapta-maia-theme breath-gtk-theme papirus-maia-icon-theme xcursor-breeze arc-gtk-theme arc-darkest-theme-git
## Install ability to change qt based application themes
paru -S --needed --noconfirm kvantum-manjaro


#install custom picom config file 
mkdir -p ~/.config/
# cd .config/
# git clone https://gist.github.com/f70dea1449cfae856d42b771912985f9.git ./picom 
    if [ -d ~/.config/rofi ]; then
        echo "Rofi configs detected, backing up..."
        mkdir ~/.config/rofi.old && mv ~/.config/rofi/* ~/.config/rofi.old/
        cp -r ./config/rofi/* ~/.config/rofi;
    else
        echo "Installing rofi configs..."
        mkdir ~/.config/rofi && cp -r ./config/rofi/* ~/.config/rofi;
    fi
    sleep 5
    echo "1)1366 x 768       2)1920 x 1080      3) 2160 x 1440"
    read -r -p "Choose your screen resolution: " res
    case $res in 
    [1])
	EWW_DIR='config/eww-1366'
	;;
    [2])
	EWW_DIR='config/eww-1920'
	;;
    [3])
	EWW_DIR='config/eww-2160'
	;;
    [*])
	EWW_DIR='config/eww-2160'
	;;
    esac
    if [ -d ~/.config/eww ]; then
        echo "Eww configs detected, backing up..."
        mkdir ~/.config/eww.old && mv ~/.config/eww/* ~/.config/eww.old/
        cp -r ./$EWW_DIR/* ~/.config/eww;
    else
        echo "Installing eww configs..."
        mkdir ~/.config/eww && cp -r ./$EWW_DIR/* ~/.config/eww;
    fi
    if [ -f ~/.config/picom.conf ]; then
        echo "Picom configs detected, backing up..."
        cp ~/.config/picom.conf ~/.config/picom.conf.old;
        cp ./config/picom.conf ~/.config/picom.conf;
    else
        echo "Installing picom configs..."
         cp ./config/picom.conf ~/.config/picom.conf;
    fi
    if [ -f ~/.config/alacritty.yml ]; then
        echo "Alacritty configs detected, backing up..."
        cp ~/.config/alacritty.yml ~/.config/alacritty.yml.old;
        cp ./config/alacritty.yml.arch ~/.config/alacritty.yml;
    else
        echo "Installing alacritty configs..."
         cp ./config/alacritty.yml.arch ~/.config/alacritty.yml;
    fi
    if [ -d ~/.config/dunst ]; then
        echo "Dunst configs detected, backing up..."
        mkdir ~/.config/dunst.old && mv ~/.config/dunst/* ~/.config/dunst.old/
        cp -r ./config/dunst/* ~/.config/dunst;
    else
        echo "Installing dunst configs..."
        mkdir ~/.config/dunst && cp -r ./config/dunst/* ~/.config/dunst;
    fi
    if [ -d ~/wallpapers ]; then
        echo "Adding wallpaper to ~/wallpapers..."
        cp ./wallpapers/yosemite-lowpoly.jpg ~/wallpapers/;
    else
        echo "Installing wallpaper..."
        mkdir ~/wallpapers && cp -r ./wallpapers/* ~/wallpapers/;
    fi
    if [ -d ~/.config/tint2 ]; then
        echo "Tint2 configs detected, backing up..."
        mkdir ~/.config/tint2.old && mv ~/.config/tint2/* ~/.config/tint2.old/
        cp -r ./config/tint2/* ~/.config/tint2;
    else
        echo "Installing tint2 configs..."
        mkdir ~/.config/tint2 && cp -r ./config/tint2/* ~/.config/tint2;
    fi
    if [ -d ~/.xmonad ]; then
        echo "XMonad configs detected, backing up..."
        mkdir ~/.xmonad.old && mv ~/.xmonad/* ~/.xmonad.old/
        cp -r ./xmonad/* ~/.xmonad/;
    else
        echo "Installing xmonad configs..."
        mkdir ~/.xmonad && cp -r ./xmonad/* ~/.xmonad;
    fi
    if [ -d ~/bin ]; then
        echo "~/bin detected, backing up..."
        mkdir ~/bin.old && mv ~/bin/* ~/bin.old/
        cp -r ./bin/* ~/bin;
	clear
    else
        echo "Installing bin scripts..."
        mkdir ~/bin && cp -r ./bin/* ~/bin/;
	clear
        echo "Please add: export PATH='\$PATH:/home/{Your_user}/bin' to your .zshrc. Replace {Your_user} with your username."
    fi
    

# done 
echo "PLEASE MAKE .xinitrc TO LAUNCH, or just use your dm" | tee ~/Note.txt
echo "run 'p10k configure' to set up your zsh" | tee -a ~/Note.txt
echo "after you this -> 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'" | tee -a ~/Note.txt
printf "\n" >> ~/Note.txt
echo "Please add: export PATH='\$PATH:/home/{Your_user}/bin' to your .zshrc if not done already. Replace {Your_user} with your username." | tee -a ~/Note.txt
echo "For startpage, copy the startpage directory into wherever you want, and set it as new tab in firefox settings." | tee -a ~/Note.txt
echo "For more info on startpage (Which is a fork of Prismatic Night), visit https://github.com/dbuxy218/Prismatic-Night#Firefoxtheme" | tee -a ~/Note.txt
echo "ALL DONE! Issue 'xmonad --recompile' and then re-login for all changes to take place!" | tee -a ~/Note.txt
echo "Make sure your default shell is ZSH too..." | tee -a ~/Note.txt
echo "Open issues on github or ask me on discord or whatever if you face issues." | tee -a ~/Note.txt
echo "Install Museo Sans as well. Frome Adobe I believe." | tee -a ~/Note.txt
echo "If the bar doesn't work, use tint2conf and set stuff up, if you're hopelessly lost(which you probably are not), open an issue." | tee -a ~/Note.txt
echo "These instructions have been saved to ~/Note.txt. Make sure to go through them."
sleep 5
xmonad --recompile

# Install LightDM and a greeter
sudo pacman -S --needed --noconfirm lightdm
sudo systemctl enable lightdm.service --force
sudo pacman -S --needed --noconfirm lightdm-webkit2-greeter
paru -S --needed --noconfirm lightdm-webkit2-theme-glorious

# Install mugshot so we can update user picture in greeter
sudo pacman -S --needed --noconfirm mugshot

cd ~/

# install zsh and make it default
# sudo pacman --noconfirm --needed -S zsh
#OhMyZsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# setup powerlevel10k for term
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

export ZSH_THEME="powerlevel10k/powerlevel10k"

p10k configure
