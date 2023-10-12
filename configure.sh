#!/usr/bin/env bash

GLOBALSOURCE=$(pwd)
REQUIRED=(git ncurses-utils zsh termux-services openssh)

#
#   CHECKS
#

echo -e "THIS SCRIPT IS DESTRUCTIVE TO PERSONAL FILES.\nONLY RUN IT ON A CLEAN TERMUX SYSTEM\n."
read -r -p "You sure you want to proceed? (y/n) " yn
case $yn in
y) ;;
*)
    echo "Terminating script..."
    exit 0
    ;;
esac

echo -e "Several packages are required for this config to function.\nRequired:\n\t${REQUIRED[*]}"
read -r -p "Do you want to proceed with their installation now? (y/n) " yn
case $yn in
y)
    echo "Updating, might take awhile..."
    apt-get update -y &>/dev/null
    apt-get upgrade -o Dpkg::Options::="--force-confnew" -y &>/dev/null

    echo "Installing dependencies..."
    # shellcheck disable=SC2048 disable=SC2086 # Unquoted is required since pkg cant find a string of packages
    pkg install -y ${REQUIRED[*]} &>/dev/null
    ;;
*)
    echo "Terminating script..."
    exit 0
    ;;
esac

#
#	FUNCTIONS
#

function configureTermux {

    # Variables
    local DESTINATION SOURCE
    DESTINATION="$HOME/.termux"
    SOURCE="$GLOBALSOURCE/termux"

    # Check if .termux exists and delete it
    echo "Setting up termux properties..."
    [[ -d "$DESTINATION" ]] && rm -rf "$DESTINATION"
    mkdir "$DESTINATION" &&
        cp -- "$SOURCE/"* "$DESTINATION" &&
        termux-reload-settings # Make sure when cp-ing that * is outside of quotes

    # If storage isnt set up, then set it up
    if [[ ! -d "$HOME/storage" ]]; then
        echo "Setting up storage..."
        termux-setup-storage
    else
        echo "Storage already set up"
    fi
}

function configureShell {

    # Variables
    local SHELL ZSHRC P10KRC P10KDIR SOURCE
    SHELL=$(basename "$SHELL")
    ZSHRC="$HOME/.zshrc"
    P10KRC="$HOME/.config/p10k.zsh"
    P10KDIR="$HOME/.local/share/powerlevel10k"
    SOURCE="$GLOBALSOURCE/config"

    # If ZSH isnt main shell, set it up.
    if [[ "$SHELL" != "zsh" ]]; then
        echo "Setting up ZSH..."
        chsh -s zsh

        # Configure ZSHRC
        # shellcheck disable=SC1090 #
        [[ ! -f "$ZSHRC" ]] && cp "$SOURCE/zshrc" "$ZSHRC" && zsh && source "$ZSHRC"

        # Pre-Configure P10K
        [[ ! -d "$HOME/.config" ]] && mkdir "$HOME/.config"
        [[ ! -f "$P10KRC" ]] && cp "$SOURCE/p10k.zsh" "$P10KRC"

        # Install P10K
        [[ ! -d "$P10KDIR" ]] && mkdir -p "$P10KDIR"
        git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$P10KDIR"
    else
        echo "Seems like ZSH is already set up."
    fi
}

function configureSSH {

    # Variables
    local DSTATUS
    DSTATUS=$(sv status sshd | grep -o "down")

    # If ssh daemon is down, enable it's service
    echo "Setting up SSH..."
    [[ "$DSTATUS" == "down" ]] && sv-enable sshd

}

function closingMessage {

    echo -e "#\n#   LAST STEPS\n#\n"
    echo "Set: run passwd to allow ssh connections"
}

#configureTermux
#configureShell
#configureSSH
#closingMessage
