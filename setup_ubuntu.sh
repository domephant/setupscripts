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
    echo $PASSWORD | sudo -S apt-get update
    echo $PASSWORD | sudo -S apt-get upgrade -y
    echo "Installing Flatpak and Flathub..."
    echo $PASSWORD | sudo -S apt-get install flatpak git curl -y
    echo $PASSWORD | sudo -S flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "Installing Flatpaks..."

    #Mandatory
    flatpak install flathub com.discordapp.Discord flathub org.gimp.GIMP -y flathub org.videolan.VLC flathub io.github.shiftey.Desktop flathub org.onlyoffice.desktopeditors -y

    #Optional
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
    echo "Installing rpm packages..."
    #Mandatory

    # VS Code
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code.deb
    echo $PASSWORD | sudo -S apt-get install ./code.deb -y

    # AppImageLauncher

    wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.deb -O appimagelauncher.deb

    # GitHub CLI

    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    # Heroic Games Launcher

    wget https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.2.6/heroic_2.2.6_amd64.deb -O heroic.deb

    # .net
    wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    echo $PASSWORD | sudo -S dpkg -i packages-microsoft-prod.deb -y
    rm packages-microsoft-prod.deb
    echo $PASSWORD | sudo -S apt-get update
    echo $PASSWORD | sudo -S apt-get install -y apt-transport-https -y
    echo $PASSWORD | sudo -S apt-get update
    # Installation (AppImageLauncher, Heroic)

    echo $PASSWORD | sudo -S apt-get install steam gh keepassxc dotnet-sdk-6.0 -y
    echo $PASSWORD | sudo -S apt-get install ./heroic.deb -y
    echo $PASSWORD | sudo -S apt-get install ./appimagelauncher.deb -y



    # Optional

    # Browser
    # Chrome
    if [[ "$CHROME" == "true" ]]; then 
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
        echo $PASSWORD | sudo -S apt-get install ./chrome.deb -y
    fi

    # Microsoft Edge
    if [[ "$EDGE" == "true" ]]; then 
        wget https://go.microsoft.com/fwlink?linkid=2149051 -O edge.deb
        echo $PASSWORD | sudo -S apt-get install ./edge.deb -y
    fi

    # Vim & Nano
    if [[ "$VIM_NANO" == "true" ]]; then 
        echo $PASSWORD | sudo -S apt-get install vim vim-gtk3 nano -y
    fi 

    # Pop Shell
    if [[ "$POP" == "true" ]]; then 
        echo $PASSWORD | sudo -S apt-get install node-typescript make git cargo rustc libgtk-3-dev
        git clone https://github.com/pop-os/shell
        cd shell
        make local-install
        cd ..
        git clone https://github.com/pop-os/shell-shortcuts
        cd shell-shortcuts
        make
        echo $PASSWORD | sudo make install
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