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

# echo $PASSWORD | sudo -S password input

echo "Enter sudo password:"
read -s PASSWORD

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

# Method Declaration
install_apps() {

    # Installation
    # TODO: Timeshift, eventually LibreOffice 

    # Upgrade system 
    
    # Flatpak
    echo "Installing Flatpak and Flathub..."
    echo $PASSWORD | sudo -S flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "Installing Flatpaks..."

    # Mandatory
    flatpak install flathub com.discordapp.Discord flathub org.gimp.GIMP -y flathub org.videolan.VLC flathub io.github.shiftey.Desktop flathub org.onlyoffice.desktopeditors -y

    # Optional
    if [[ "$SPOTIFY" == "true" ]]; then
        flatpak install flathub com.spotify.Client -y
    fi
    if [[ "$POSTMAN" == "true" ]]; then
        sudo -S flatpak install flathub com.getpostman.Postman -y 
    fi
    if [[ "$THUNDERBIRD" == "true" ]]; then
        sudo -S flatpak install flathub org.mozilla.Thunderbird -y
    fi

    echo "Installing Snaps..."
    echo "Installing arch packages..."
    #Mandatory

    # Necessary imports

    # VS Code

    # Steam

    # AppImageLauncher

    # GitHub CLI

    # Heroic Games Launcher 

    # Installation (.net, KeepassXC, Github CLI, Steam, VS Code, AppImageLauncher, Heroic)

    # Optional

    # Browser
    # Chrome
    if [[ "$CHROME" == "true" ]]; then 
        # Chrome Install
    fi

    # Microsoft Edge
    if [[ "$EDGE" == "true" ]]; then 
        # Edge Install
    fi

    # Vim & Nano
    if [[ "$VIM_NANO" == "true" ]]; then 
        # GVim & Nano Install
    fi 

    # Pop Shell
    if [[ "$POP" == "true" ]]; then 

        # TODO: Source build or AUR? 
        echo $PASSWORD | sudo -S dnf install cargo rust gtk3-devel gnome-shell-extension-pop-shell -y 
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
    ./jetbrains-toolbox &
    disown



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
echo "- Steam"
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
