#!/data/data/com.termux/files/usr/bin/bash

source="$(pwd)/rice"

check_dir_exists() {
    file=$1
    if [ -d "$file" ]; then
        exists=true
    else
        printf "%s doesn't exist\n" "$file"
        exists=false
        $2
    fi
}

check_file_exists() {
    file=$1
    if [ -f "$file" ]; then
        exists=true
    else
        printf "%s doesn't exist\n" "$file"
        exists=false
        $2
    fi
}

printf "This script is designed for Termux installation only\n"
read -r -p "You sure you want to proceed? (y/n) " yn
case $yn in
y) ;;
*)
    printf "Terminating script...\n"
    exit 0
    ;;
esac

printf "Installing dependencies listed in dependencies.txt...\n"
# shellcheck disable=SC2207
DEPLIST=($(sed -e 's/#.*$//' -e '/^$/d' dependencies.txt))
apt-get update -y 1>/dev/null
apt-get upgrade -o Dpkg::Options::="--force-confnew" -y 1>/dev/null
# shellcheck disable=SC2048 disable=SC2086 # Unquoted is required since pkg cant find a string of packages
pkg install -y ${DEPLIST[*]} 1>/dev/null
printf "Installed dependencies\n"

check_dir_exists "$HOME/.termux"
if $exists; then
    printf "your .termux directory already exists\n"
else
    printf "creating .termux directory for the user\n"
    mkdir -p "$HOME/.termux"
fi

check_dir_exists "$HOME/storage"
if $exists; then
    printf "your storage directory already exists\n"
else
    printf "setting storage up for the user\n"
    termux-setup-storage
fi

check_dir_exists "$HOME/.config"
if $exists; then
    printf "your .config directory already exists\n"
else
    printf "creating .config directory for the user\n"
    mkdir -p "$HOME/.config"
fi

check_dir_exists "$HOME/.config/nvim"
if $exists; then
    printf "your nvim config directory already exists\n"
else
    printf "creating nvim directory for the user\n"
    mkdir -p "$HOME/.config/nvim"
fi

printf "Adding dots to .termux\n"
cp -f "$source/dots/termux.properties" "$HOME/.termux/"
cp -f "$source/dots/colors.properties" "$HOME/.termux/"
cp -f "$source/dots/font.ttf" "$HOME/.termux/"
termux-reload-settings

printf "Adding dots to nvim\n"
cp -f "$source/dots/init.nvim" "$HOME/.config/nvim/"

printf "Adding dots to user home\n"
cp -f "$source/dots/.zshrc" "$HOME"
cp -f "$source/dots/.zprofile" "$HOME"
cp -f "$source/dots/.p10k.zsh" "$HOME"
echo "termux-wake-lock" >"$HOME/.zlogin"
echo "termux-wake-unlock" >"$HOME/.zlogout"
touch "$HOME/.hushlogin"

check_dir_exists "$HOME/.config/powerlevel10k"
if $exists; then
    printf "your powerlevel10k theme is already installed\n"
else
    printf "cloning powerlevel10k from github\n"
    git clone --quiet --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$HOME/.config/powerlevel10k"
fi

printf "\nLAST STEPS\n"
printf "First of all, add this to your .ssh/config on PC:\n\nHost phone\n\tHostName termux_LAN_address\n\tUser WHOAMI_to_check_username\n\tPort 8022\n"
printf "\nNext, run:\n\tpasswd\n\t# Set password in termux for initial ssh connection\n"
printf "\n\tssh-keygen -t rsa -b 4096 -f id_rsa\n\t# Generate ssh keys on PC\n"
printf "\n\trsync id_rsa.pub phone:.ssh\n\t# Send public key from PC to termux\n"
printf "\n\tssh phone cat .ssh/id_rsa.pub >> .ssh/authorized_keys\n\t# Add public key to authorized keys file\n"

chsh -s zsh
exec zsh
