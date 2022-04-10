#! /bin/bash

# Variables

# User inputs

# Installation
sudo dnf update --refresh --assumeno
sudo dnf upgrade --refresh -y
echo "Installing Flatpak and Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Installing Flatpaks..."

#Mandatory
flatpak install flathub com.discordapp.Discord flathub org.gimp.GIMP -y flathub org.videolan.VLC flathub io.github.shiftey.Desktop flathub org.onlyoffice.desktopeditors -y

#Optional
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.getpostman.Postman -y 
flatpak install flathub org.mozilla.Thunderbird -y

echo "Installing Snaps..."
echo "Installing rpm packages..."
#Mandatory
#TODO: Timeshift, eventually LibreOffice 

# Necessary imports

# VS Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update

# Steam

sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# AppImageLauncher
wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm
# GitHub CLI
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

# Heroic Games Launcher 
wget https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.2.6/heroic-2.2.6.x86_64.rpm

# Installation

sudo dnf install dotnet-sdk-6.0 keepassxc gh steam code -y
sudo dnf localinstall -y appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm 
sudo dnf localinstall -y heroic-2.2.6.x86_64.rpm


# Optional

# Browser
# Chrome
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable -y

# Microsoft Edge
sudo dnf install dnf-plugins-core -y
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo dnf update --refresh -y
sudo dnf install microsoft-edge-stable -y

sudo dnf install vim vim-x11 nano -y 

sudo dnf install cargo rust gtk3-devel gnome-shell-extension-pop-shell -y 
git clone https://github.com/pop-os/shell-shortcuts
cd shell-shortcuts
make
sudo make install
cd..

echo "Installing AppImages..."
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.23.11731.tar.gz
tar -xvf jetbrains-toolbox-1.23.11731.tar.gz
cd jetbrains-toolbox-1.23.11731
chmod +x jetbrains-toolbox
./jetbrains-toolbox &


echo "Installing GNOME extensions..."
echo "Done!"