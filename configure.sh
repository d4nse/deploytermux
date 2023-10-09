#!/usr/bin/bash

SOURCE=$(pwd)
REQUIRED=(git ncurses-utils)
echo -e "This script is non-destructive, feel free to run it accidentally every evening.\n"

#
#   CHECKS 
#

if ! command -v "git" &> /dev/null;
then
    echo "Git is required for this script to run successfully."
    read -p "Do you want to proceed with git installation? (y/n) " yn
    case $yn in
        y) 
            pkg install git;;
        n)
            echo "Terminating script..."
            exit 0;;
        *) 
            echo "Invalid response, terminating anyways..."
            exit 1;;
    esac
fi

#
#	FUNCTIONS	
#

function configureTermux {

        # Variables
        local DIR="$HOME/.termux"
        local PROPFILE="$DIR/termux.properties"
        local COLORFILE="$DIR/color.properties"
        local FONTFILE="$DIR/font.ttf"
        local MOTDFILE="$DIR/motd.sh"
        local SOURCE="$SOURCE/termux"
        local SWITCH="false"
        
        # If config directory doesnt exist, then create it
        [[ ! -d "$DIR" ]] && mkdir "$DIR"

        # If storage isnt set up, then set it up
        if [[ ! -d "$HOME/storage" ]];
        then
                echo "Setting up storage..."
                termux-setup-storage
        else
                echo "Storage already set up"
        fi
        
        # If termux.properties doesnt exist, then copy it from repo
        if [[ ! -f "$PROPFILE" ]];
        then
                echo "Setting up properties..."
                cp "$SOURCE/termux.properties" "$DIR" && local SWITCH="true"
        else
                echo "Properties file already exist."
        fi
        
        # If color.properties doesnt exist, then copy it from repo
        if [[ ! -f "$COLORFILE" ]];
        then
              	echo "Setting up colorscheme..."
                cp "$SOURCE/color.properties" "$DIR" && local SWITCH="true"
        else
            	echo "Colorscheme file already exists."
        fi
        
        # If font.ttf doesnt exist, then copy it from repo
        if [[ ! -f "$FONTFILE" ]];
        then
        	    echo "Setting up font..."
                cp "$SOURCE/font.ttf" "$DIR" && local SWITCH="true"
        else
        	    echo "Font file already exists."
        fi
        
        # MOTD
        if [[ ! -f "$MOTDFILE" ]];
        then
        	    echo "Setting up MOTD..."
                cp "$SOURCE/motd.sh" "$DIR"
        else
        	    echo "MOTD file already exists"
        fi
        
        # Reload settings if necessary
        [[ "$SWITCH" == "true" ]] && termux-reload-settings
}

function configureShell {

    # Variables
	local SHELL=$(basename $SHELL)
	local ZSHRC="$HOME/.zshrc"
    local P10KRC="$HOME/.config/p10k.zsh"
    local P10KDIR="$HOME/.local/share/powerline10k"
    local SOURCE="$SOURCE/config"

    # If ZSH isnt main shell, set it up.
	if [[ "$SHELL" == "bash" ]];
	then
		echo "Setting up ZSH..."
		chsh -s zsh

        # Configure ZSHRC
		[[ ! -f "$ZSHRC" ]] && cp "$SOURCE/zshrc" "$ZSHRC"

        # Pre-Configure P10K
        [[ ! -f "$P10KRC" ]] && cp "$SOURCE/p10k.zsh" "$P10KRC"

        # Install P10K
        [[ ! -d "$P10KDIR" ]] && mkdir -p "$P10KDIR"
        git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$P10KDIR" 
    else
        echo "Seems like ZSH is already set up."
	fi

}

function configureSSH {

}
