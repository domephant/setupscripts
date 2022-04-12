#! /bin/bash

# Variables

SPOTIFY="false"
POSTMAN="false"
THUNDERBIRD="false"

CHROME="false"
EDGE="false"
VIM_NANO="false"
POP="false"

echo "Enter password: "
read -s PASSWORD

# Method Declaration
install_apps() {

    # Installation
    # TODO: Timeshift, eventually LibreOffice 
    sudo -p $PASSWORD dnf update --refresh --assumeno
    sudo -p $PASSWORD dnf upgrade --refresh -y
    echo "Installing Flatpak and Flathub..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "Installing Flatpaks..."

    #Mandatory
    flatpak install flathub com.discordapp.Discord flathub org.gimp.GIMP -y flathub org.videolan.VLC flathub io.github.shiftey.Desktop flathub org.onlyoffice.desktopeditors -y

    #Optional
    if [[$SPOTIFY == "true"]];then
        flatpak install flathub com.spotify.Client -y
    fi
    if [[$POSTMAN == "true"]];then
        flatpak install flathub com.getpostman.Postman -y 
    fi
    if [[$THUNDERBIRD == "true"]];then
        flatpak install flathub org.mozilla.Thunderbird -y
    fi

    echo "Installing Snaps..."
    echo "Installing rpm packages..."
    #Mandatory

    # Necessary imports

    # VS Code
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo -p $PASSWORD dnf check-update

    # Steam

    sudo -p $PASSWORD dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

    # AppImageLauncher
    wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm
    # GitHub CLI
    sudo -p $PASSWORD dnf install 'dnf-command(config-manager)'
    sudo -p $PASSWORD dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

    # Heroic Games Launcher 
    wget https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.2.6/heroic-2.2.6.x86_64.rpm

    # Installation

    sudo -p $PASSWORD dnf install dotnet-sdk-6.0 keepassxc gh steam code -y
    sudo -p $PASSWORD dnf localinstall -y appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm 
    sudo -p $PASSWORD dnf localinstall -y heroic-2.2.6.x86_64.rpm


    # Optional

    # Browser
    # Chrome
    if [[$CHROME == "true"]]; then 
        sudo -p $PASSWORD dnf install fedora-workstation-repositories
        sudo -p $PASSWORD dnf config-manager --set-enabled google-chrome
        sudo -p $PASSWORD dnf install google-chrome-stable -y
    fi

    # Microsoft Edge
    if [[$EDGE == "true"]]; then 
        sudo -p $PASSWORD dnf install dnf-plugins-core -y
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo -p $PASSWORD dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
        sudo -p $PASSWORD dnf update --refresh -y
        sudo -p $PASSWORD dnf install microsoft-edge-stable -y
    fi

    # Vim & Nano
    if [[$VIM_NANO == "true"]]; then 
        sudo -p $PASSWORD dnf install gvim nano -y
    fi 

    # Pop Shell
    if [[$POP == "true"]]; then 
        sudo -p $PASSWORD dnf install cargo rust gtk3-devel gnome-shell-extension-pop-shell -y 
        git clone https://github.com/pop-os/shell-shortcuts
        cd shell-shortcuts
        make
        sudo -p $PASSWORD make install
        cd..
    fi

    echo "Installing AppImages..."
    wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.23.11731.tar.gz
    tar -xvf jetbrains-toolbox-1.23.11731.tar.gz
    cd jetbrains-toolbox-1.23.11731
    chmod +x jetbrains-toolbox
    ./jetbrains-toolbox &


    echo "Installing GNOME extensions..."
    echo "Done!"
}

# Command line arguments processing

for var in "$@"; do
    case "$var" in 
        --spotify) 
            SPOTIFY="true"
        ;;
        --postman) 
            POSTMAN="true"
        ;;
        --thunderbird) 
            THUNDERBIRD="true"
        ;;
        --chrome)
            CHROME="true"
        ;;
        --edge)
            EDGE="true"
        ;;
        --vimnano) 
            VIM_NANO="true"
        ;;
        --pop)
            POP="true"
        ;;
    esac
done

echo "You're about to install the following applications / extensions:"
echo "- KeePassXC"
echo "- GIMP"
echo "- Discord"
echo "- VLC"
echo "- VS Code"
echo "- Steam"
echo "- GitHub Desktop"
echo "- AppImageLauncher"
echo "- GitHub CLI"
echo "- OnlyOffice"
echo "- Heroic Games Launcher"

if [[ $SPOTIFY == "true" ]]; then
    echo "- Spotify"
fi

if [[ $POSTMAN == "true" ]]; then
    echo "- Postman"
fi

if [[ $THUNDERBIRD == "true" ]]; then
    echo "- Thunderbird"
fi

if [[ $CHROME == "true" ]]; then
    echo "- Google Chrome"
fi

if [[ $EDGE == "true" ]]; then
    echo "- Microsoft Edge"
fi

if [[ $VIM_NANO == "true" ]]; then
    echo "- Vim & Nano"
fi

if [[ $POP == "true" ]]; then
    echo "- Pop! Shell"
fi

while true; do
    read -p "Proceed?" yn
    case $yn in
        [Yy]* ) 
            install_apps
        ;;
        [Nn]* ) 
            echo "Cancelled."
            exit 0
        ;;
        * ) echo "Please answer yes or no.";;
    esac
done
