#!/usr/bin/env bash

if [[ -d "/sdcard" ]]; then
    printf "Please, run this script on your computer. Not on termux.\n"
    exit 1
fi

printf "PREREQUISITES:\n\tset PASSWD on termux\n\tMake sure your SSHD or DROPBEAR are running\n"
read -rp "Press enter when done."
exit

config_file="$HOME/.ssh/config"
search_string=$(grep -o "Host phone" "$config_file")
if [[ -z "$search_string" ]]; then
    printf "Didn't find termux host in %s\n" "$config_file"
    printf "I can configure it, just answer some questions:\n\n"
    read -rp "Private ip of your phone: " lan
    new_host="\nHost phone\n\tHostName ${lan}\n\tPort 8022\n"
    printf "%b\n" "$new_host" >>"$config_file"
fi

if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
    printf "Didn't find id_rsa public key in %s/.ssh/\n" "$HOME"
    printf "I will create one\n"
    ssh-keygen -t rsa -b 4096
fi

printf "Remember to set your passwd on termux, im going in\n"
ssh phone "mkdir -p ~/.ssh && cat > ~/.ssh/authorized_keys" <"$HOME/.ssh/id_rsa.pub"

printf "Probably done.\n"
exit 0
