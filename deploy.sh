#!/data/data/com.termux/files/usr/bin/bash

source="$(pwd)"
rice="$source/rice"

if [ "$PREFIX" != "/data/data/com.termux/files/usr" ]; then
  printf "ERROR: PREFIX is not /data/data/com.termux/files/usr\n"
  printf "This script is designed to be ran in Termux only\n"
  exit 1
fi

# Update and install deps
printf "Updating package database...\n"
pkg update -y
printf "Upgrading packages...\n"
apt-get -o Dpkg::Options::="--force-confnew" -y upgrade
printf "Installing requirements...\n"
xargs pkg install -y < "$source/requirements.txt"

# Setup dirs
if [[ ! -d "$HOME/.termux" ]]; then mkdir -p "$HOME/.termux"; fi
if [[ ! -d "$HOME/.config/nvim" ]]; then mkdir -p "$HOME/.config/nvim"; fi

# Drop dots
printf "Dropping dots\n"
cp "$rice/dots/termux.properties" "$HOME/.termux/"
cp "$rice/dots/colors.properties" "$HOME/.termux/"
cp "$rice/dots/font.ttf" "$HOME/.termux/"
cp "$rice/dots/init.vim" "$HOME/.config/nvim/"
cp "$rice/dots/.zshrc" "$HOME"
cp "$rice/dots/.zprofile" "$HOME"
cp "$rice/dots/.p10k.zsh" "$HOME"
echo "termux-wake-lock" >"$HOME/.zlogin"
echo "termux-wake-unlock" >"$HOME/.zlogout"
touch "$HOME/.hushlogin"

# Install theme
if [[ ! -d "$HOME/.config/powerlevel10k" ]]; then
    printf "cloning powerlevel10k from github\n"
    git clone --quiet --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$HOME/.config/powerlevel10k"
fi

# Get access to phone storage
if [[ ! -d "$HOME/storage" ]]; then
  termux-setup-storage
fi

# Change shell to ZSH
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

# Reload settings lol
termux-reload-settings

printf "Done.\n"

exec zsh
