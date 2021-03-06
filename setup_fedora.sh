#! /bin/bash

# Variables
PASSWORD=""

SPOTIFY="false"
POSTMAN="false"
THUNDERBIRD="false"

CHROME="false"
EDGE="false"
VIM_NANO="false"
POP="false"
STEAM="false"
ONENOTE="false"

# echo $PASSWORD | sudo -S password input

echo "Enter sudo password:"
read -s PASSWORD

# Command line arguments processing

for var in "$@"; do
    case "$var" in 
        --spotify|-sp) 
            SPOTIFY="true"
        ;;
        --postman|-pm) 
            POSTMAN="true"
        ;;
        --thunderbird|-tb) 
            THUNDERBIRD="true"
        ;;
        --chrome|-c)
            CHROME="true"
        ;;
        --edge|-e)
            EDGE="true"
        ;;
        --vimnano|-vn) 
            VIM_NANO="true"
        ;;
        --pop|-p)
            POP="true"
        ;;
        --steam|-s)
            STEAM="true"
        ;;
        --onenote|-on)
            ONENOTE="true"
        ;;
    esac
done

# Method Declaration
install_apps() {

    # Installation
    # TODO: Timeshift, eventually LibreOffice 
    echo $PASSWORD | sudo -S dnf update --refresh --assumeno
    echo $PASSWORD | sudo -S dnf upgrade --refresh -y
    echo $PASSWORD | sudo -S dnf install snapd -y
    echo $PASSWORD | sudo ln -s /var/lib/snapd/snap /snap
    echo "Installing Flatpak and Flathub..."
    echo $PASSWORD | sudo -S flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "Installing Flatpaks..."

    #Mandatory
    flatpak install flathub com.discordapp.Discord flathub org.gimp.GIMP -y flathub org.videolan.VLC flathub io.github.shiftey.Desktop flathub org.onlyoffice.desktopeditors -y

    #Optional
    if [[ "$SPOTIFY" == "true" ]]; then
        flatpak install flathub com.spotify.Client -y
    fi
    if [[ "$POSTMAN" == "true" ]]; then
        flatpak install flathub com.getpostman.Postman -y 
    fi
    if [[ "$THUNDERBIRD" == "true" ]]; then
        flatpak install flathub org.mozilla.Thunderbird -y
    fi

    echo "Installing Snaps..."
    if [[ "$ONENOTE" == "true" ]]; then
        echo $PASSWORD | sudo snap install p3x-onenote 
    fi
    echo "Installing rpm packages..."
    # Mandatory

    # Necessary imports

    # VS Code
    echo $PASSWORD | sudo -S rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo $PASSWORD | sudo -S sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    echo $PASSWORD | sudo -S dnf check-update

    # Steam

    echo $PASSWORD | sudo -S dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

    # AppImageLauncher
    # wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm
    # GitHub CLI
    echo $PASSWORD | sudo -S dnf install 'dnf-command(config-manager)'
    echo $PASSWORD | sudo -S dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

    # Heroic Games Launcher 
    echo $PASSWORD | sudo -S dnf copr enable atim/heroic-games-launcher -y

    # Installation

    echo $PASSWORD | sudo -S dnf install dotnet-sdk-6.0 keepassxc gh code -y
    # echo $PASSWORD | sudo -S dnf localinstall -y appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm 
    echo $PASSWORD | sudo -S dnf install heroic-games-launcher-bin -y


    # Optional

    # Browser
    # Chrome
    if [[ "$CHROME" == "true" ]]; then 
        echo $PASSWORD | sudo -S dnf install fedora-workstation-repositories
        echo $PASSWORD | sudo -S dnf config-manager --set-enabled google-chrome
        echo $PASSWORD | sudo -S dnf install google-chrome-stable -y
    fi

    # Microsoft Edge
    if [[ "$EDGE" == "true" ]]; then 
        echo $PASSWORD | sudo -S dnf install dnf-plugins-core -y
        echo $PASSWORD | sudo -S dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
        echo $PASSWORD | sudo -S dnf update --refresh -y
        echo $PASSWORD | sudo -S dnf install microsoft-edge-stable -y
    fi

    # Vim & Nano
    if [[ "$VIM_NANO" == "true" ]]; then 
        echo $PASSWORD | sudo -S dnf install gvim nano -y
    fi 

    # Vim & Nano
    if [[ "$STEAM" == "true" ]]; then 
        echo $PASSWORD | sudo -S dnf install steam -y
    fi 

    # Pop Shell
    if [[ "$POP" == "true" ]]; then 
        echo $PASSWORD | sudo -S dnf install cargo rust gtk3-devel gnome-extensions-app gnome-shell-extension-pop-shell -y 
        git clone https://github.com/pop-os/shell-shortcuts
        cd shell-shortcuts
        make
        echo $PASSWORD | sudo -S make install
        cd ..
        gnome-extensions enable pop-shell@system76.com
    fi

    echo "Installing AppImages..."
    wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.23.11731.tar.gz
    tar -xvf jetbrains-toolbox-1.23.11731.tar.gz
    cd jetbrains-toolbox-1.23.11731
    chmod +x jetbrains-toolbox
    ./jetbrains-toolbox 
    



    echo "Installing GNOME extensions..."
    echo "Done!"
}

#Install Comfirmation

echo "You're about to install the following applications / extensions:"
echo "- KeePassXC"
echo "- GIMP"
echo "- Discord"
echo "- VLC"
echo "- VS Code"
echo "- GitHub Desktop"
echo "- AppImageLauncher"
echo "- GitHub CLI"
echo "- OnlyOffice"
echo "- Heroic Games Launcher"

if [[ "$SPOTIFY" == "true" ]]; then
    echo "- Spotify"
fi

if [[ "$POSTMAN" == "true" ]]; then
    echo "- Postman"
fi

if [[ "$THUNDERBIRD" == "true" ]]; then
    echo "- Thunderbird"
fi

if [[ "$CHROME" == "true" ]]; then
    echo "- Google Chrome"
fi

if [[ "$EDGE" == "true" ]]; then
    echo "- Microsoft Edge"
fi

if [[ "$VIM_NANO" == "true" ]]; then
    echo "- Vim & Nano"
fi

if [[ "$POP" == "true" ]]; then
    echo "- Pop! Shell"
fi

if [[ "$STEAM" == "true" ]]; then
    echo "- Steam"
fi

if [[ "$ONENOTE" == "true" ]]; then
    echo "- P3X Onenote"
fi

while true; do
    read -p "Proceed? (y/n)" yn
    case $yn in
        [Yy]* ) 
            install_apps
            exit 0
        ;;
        [Nn]* ) 
            echo "Cancelled."
            exit 0
        ;;
        * ) echo "Please answer yes or no.";;
    esac
done
