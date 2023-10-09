#!/usr/bin/bash


read -r -d '' TERMUX_PROPERTIES <<- EOT
extra-keys = [[ \
   {key: ESC, popup: {macro: "CTRL f d", display: "tmux exit"}}, \
   {key: CTRL, popup: {macro: "CTRL f BKSP", display: "tmux ←"}}, \
   {key: ALT, popup: {macro: "CTRL f TAB", display: "tmux →"}}, \
   {key: LEFT, popup: HOME}, \
   {key: DOWN, popup: PGDN}, \
   {key: UP, popup: PGUP}, \
   {key: RIGHT, popup: END}, \
   {key: KEYBOARD, popup: {macro: "CTRL d", display: exit}} \
 ]]
EOT

read -r -d '' TERMUX_COLORS <<- EOT
# http=//xcolors.net/dl/neon
background=#171717
foreground=#F8F8F8
# black
color0=#171717
color8=#38252C
# red
color1=#D81765
color9=#FF0000
# green
color2=#97D01A
color10=#76B639
# yellow
color3=#FFA800
color11=#E1A126
# blue
color4=#16B1FB
color12=#289CD5
# magenta
color5=#FF2491
color13=#FF2491
# cyan
color6=#0FDCB6
color14=#0A9B81
# white
color7=#EBEBEB
color15=#F8F8F8
EOT

read -r -d '' MOTD << EOT
#!/data/data/com.termux/files/usr/bin/bash

# Setup TERMUX_APP_PACKAGE_MANAGER
source "/data/data/com.termux/files/usr/bin/termux-setup-package-manager" || exit 1

ARRAY[0]="Your eyes deceive you."
ARRAY[1]="The system needs you."
ARRAY[2]="You are the Operator."
randnum=\$(( \$RANDOM % 3 ))
MESSAGE="\${ARRAY[\$randnum]}"

echo -e "



		\$MESSAGE



				      danse@nethunter

"
EOT


#	FUNCTIONS	#

function configureTermux {
	local FONTNAME="Hack"
	local FONTURL="https://github.com/adi1090x/termux-style/raw/master/fonts/$FONTNAME.ttf"
	local DIR="$HOME/.termux"
	local PROPFILE="$DIR/termux.properties"
	local COLORFILE="$DIR/colors.properties"
	local FONTFILE="$DIR/font.ttf"
	local MOTDFILE="$DIR/motd.sh"
	local SWITCH="false"

	if [[ ! -d "$DIR" ]];
	then
		mkdir "$DIR"
	fi
	
	# Storage
	if [[ ! -d "$HOME/storage" ]];
	then
		echo "Setting up storage..."
		termux-setup-storage
	else
		echo "Storage already set up"
	fi

	# Properties
	if [[ ! -f "$PROPFILE" ]];
	then
		echo "Setting up properties..."
		echo "$TERMUX_PROPERTIES" > "$PROPFILE" && local SWITCH="true"
	else
		echo "Properties file already exist."
	fi

	# Colorsheme
	if [[ ! -f "$COLORFILE" ]];
	then
		echo "Setting up colorscheme..."
		echo "$TERMUX_COLORS" > "$COLORFILE" && local SWITCH="true"
	else
		echo "Colorscheme file already exists."
	fi

	# Font
	if [[ ! -f "$FONTFILE" ]];
	then
		echo "Downloading font..."
		curl -sL "$FONTURL" -o "$FONTFILE" && local SWITCH="true"
	else
		echo "Font file already exists."
	fi
	
	# MOTD
	if [[ ! -f "$MOTDFILE" ]];
	then
		echo "Setting up motd..."
		echo "$MOTD" > "$MOTDFILE"
	else
		echo "Motd file already exists"
	fi

	if [[ "$SWITCH" == "true" ]];
	then
		termux-reload-settings
	fi
}

function configureZSH {
	local shell=$(basename $SHELL)
	local rc="$HOME/.zshrc"
	if [[ "$shell" == "bash" ]];
	then
		echo "Setting up ZSH..."
		chsh -s zsh

		if [[ ! -f "$rc" ]];
		then
			echo "Configuring ZSH..."
			#TODO
		else
			echo "ZSHRC file already exists."
		fi
	fi

}

function configureZSHTheme {
	
}

function cout {
	echo -e "#\n#	$1\n#"
}


#	EXECUTION	#

cout "SETTING UP TERMUX"
configureTermux

cout "GETTING PACKAGES"
pkg install -y git zsh neovim termux-api tree file

cout "CONFIGURING PACKAGES"
configureZSH

