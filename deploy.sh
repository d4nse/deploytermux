#!/data/data/com.termux/files/usr/bin/bash

source="$(pwd)/rice"

mkdirs() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

printf "This script is designed to be ran on Termux only\n"
read -r -p "You sure you want to proceed? (y/n) " yn
case $yn in
[Yy] | [Yy][Ee][Ss]) ;;
*)
    printf "Terminating script...\n"
    exit 0
    ;;
esac

printf "Updating apt database...\n"
apt-get update -y 1>/dev/null
printf "Upgrading everything...\n"
apt-get upgrade -o Dpkg::Options::="--force-confnew" -y 1>/dev/null
printf "Installing dependencies listed in dependencies.txt...\n"
# shellcheck disable=SC2207
DEPLIST=($(sed -e 's/#.*$//' -e '/^$/d' dependencies.txt))
# shellcheck disable=SC2048 disable=SC2086 # Unquoted is required since pkg cant find a string of packages
pkg install -y ${DEPLIST[*]} 1>/dev/null
printf "Installed dependencies\n"

mkdirs "$HOME/.termux"
printf "Adding dots to .termux\n"
cp -f "$source/dots/termux.properties" "$HOME/.termux/"
cp -f "$source/dots/colors.properties" "$HOME/.termux/"
cp -f "$source/dots/font.ttf" "$HOME/.termux/"
termux-reload-settings

mkdirs "$HOME/.config/nvim"
printf "Adding dots to nvim\n"
cp -f "$source/dots/init.vim" "$HOME/.config/nvim/"

[[ ! -d "$HOME/storage" ]] && termux-setup-storage

printf "Adding dots to user home\n"
cp -f "$source/dots/.zshrc" "$HOME"
cp -f "$source/dots/.zprofile" "$HOME"
cp -f "$source/dots/.p10k.zsh" "$HOME"
echo "termux-wake-lock" >"$HOME/.zlogin"
echo "termux-wake-unlock" >"$HOME/.zlogout"
touch "$HOME/.hushlogin"

if [[ -d "$HOME/.config/powerlevel10k" ]]; then
    printf "your powerlevel10k theme is already installed\n"
else
    printf "cloning powerlevel10k from github\n"
    git clone --quiet --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$HOME/.config/powerlevel10k"
fi

PRIVATEIP=$(ifconfig 2>/dev/null | grep -oE '192\.168\.[0-9]{1,3}\.[0-9]{1,3}' | head -n1)
printf "\nLAST STEPS\n"
printf "1. Set passwd on termux\n"
printf "2. On pc, run: \n\tssh-keygen -t rsa -b 4096 (No need for that if you already have keys generated)\n"
printf "3. And this:\n\tssh %s mkdir -p ~/.ssh && cat > ~/.ssh/authorized_keys <\$HOME/.ssh/id_rsa.pub\n" "$PRIVATEIP"
printf "DONE! Now your public keys are in termux.\n"

chsh -s zsh
exec zsh
