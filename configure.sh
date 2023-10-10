#!/usr/bin/bash

GLOBALSOURCE=$(pwd)
REQUIRED=(git ncurses-utils zsh termux-services openssh)

#
#   CHECKS 
#

echo -e "Several packages are required for this config to function.\nRequired:\n\t${REQUIRED[*]}"
read -r -p "Do you want to proceed with their installation now? (y/n) " yn
case $yn in
    y)  
        pkg install "${REQUIRED[@]}";;
    n)
        echo "Terminating script..."
        exit 0;;
    *) 
        echo "Invalid response, terminating anyways..."
        exit 1;;
esac

#
#	FUNCTIONS	
#

function configureTermux {

        # Variables
        local DEST PROP COLOR FONT MOTD SOURCE SWITCH
        DEST="$HOME/.termux"
        PROP="$DEST/termux.properties"
        COLOR="$DEST/colors.properties"
        FONT="$DEST/font.ttf"
        MOTD="$DEST/motd.sh"
        SOURCE="$GLOBALSOURCE/termux"
        SWITCH="false"
        
        # If config directory doesnt exist, then create it
        [[ ! -d "$DEST" ]] && mkdir "$DEST"

        # If storage isnt set up, then set it up
        if [[ ! -d "$HOME/storage" ]];
        then
                echo "Setting up storage..."
                termux-setup-storage
        else
                echo "Storage already set up"
        fi
        
        # If termux.properties doesnt exist, then copy it from repo
        if [[ ! -f "$PROP" ]];
        then
                echo "Setting up properties..."
                cp "$SOURCE/termux.properties" "$DEST" && local SWITCH="true"
        else
                echo "Properties file already exist."
        fi
        
        # If color.properties doesnt exist, then copy it from repo
        if [[ ! -f "$COLOR" ]];
        then
              	echo "Setting up colorscheme..."
                cp "$SOURCE/colors.properties" "$DEST" && local SWITCH="true"
        else
            	echo "Colorscheme file already exists."
        fi
        
        # If font.ttf doesnt exist, then copy it from repo
        if [[ ! -f "$FONT" ]];
        then
        	    echo "Setting up font..."
                cp "$SOURCE/font.ttf" "$DEST" && local SWITCH="true"
        else
        	    echo "Font file already exists."
        fi
        
        # If motd script doesnt exist, then copy it from repo
        if [[ ! -f "$MOTD" ]];
        then
        	    echo "Setting up MOTD..."
                cp "$SOURCE/motd.sh" "$DEST"
        else
        	    echo "MOTD file already exists"
        fi
        
        # Reload settings if necessary
        [[ "$SWITCH" == "true" ]] && termux-reload-settings
}

function configureShell {

    # Variables
    local SHELL ZSHRC P10KRC P10KDIR SOURCE
	SHELL=$(basename "$SHELL")
	ZSHRC="$HOME/.zshrc"
    P10KRC="$HOME/.config/p10k.zsh"
    P10KDIR="$HOME/.local/share/powerline10k"
    SOURCE="$GLOBALSOURCE/config"

    # If ZSH isnt main shell, set it up.
	if [[ "$SHELL" != "zsh" ]];
	then
		echo "Setting up ZSH..."
		chsh -s zsh

        # Configure ZSHRC 
        # shellcheck disable=SC1090 # 
		[[ ! -f "$ZSHRC" ]] && cp "$SOURCE/zshrc" "$ZSHRC" && source "$ZSHRC"

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

configureTermux
configureShell
configureSSH
closingMessage