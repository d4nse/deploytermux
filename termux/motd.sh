#!/data/data/com.termux/files/usr/bin/bash

# Setup TERMUX_APP_PACKAGE_MANAGER
source "/data/data/com.termux/files/usr/bin/termux-setup-package-manager" || exit 1

# Define messages of the day
MOTDARR=(
"Your eyes deceive you."
"And illusion fools you all."
"Ends all."
"You die as you lived."
"Ahem. Gentlemen."
"The system needs you."
"You are the Operator."

)

# Choose random message of the day
arrLength="${#MOTDARR[@]}"
randNum=$(( $RANDOM % $arrLength ))
MESSAGE="${MOTDARR[$randNum]}"

# Get terminal window info
COLUMNS=$(tput cols)

# Get ssh info
DSTATUS=$(sv status sshd | grep -o "down")
PRIVATEIP=$(ifconfig 2>/dev/null | grep -oE '192\.168\.[0-9]{1,3}\.[0-9]{1,3}' | head -n1)

# Print 
echo -e "\n\n\n"
printf "%*s\n" $(((${#MESSAGE}+$COLUMNS)/2)) "$MESSAGE"
echo -e "\n\n\n"
printf "%*s\n" $(($COLUMNS-5)) "d4nse"
if [[ "$DSTATUS" == "down" ]];
then
    printf "%*s\n" $(($COLUMNS-5)) "SSHD is down"
else
    printf "%*s\n" $(($COLUMNS-5)) "SSHD on $PRIVATEIP"
fi

    

