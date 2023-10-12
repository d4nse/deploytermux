MOTD=(
"Your eyes deceive you."
"And illusion fools you all."
"Ends all."
"You die as you lived."
"Ahem. Gentlemen."
"The system needs you."
"You are the Operator."

)
MESSAGE="${MOTD[$(( $RANDOM % ${#MOTD[@]} ))]}"
COLUMNS=$(tput cols)
PRIVATEIP=$(ifconfig 2>/dev/null | grep -oE '192\.168\.[0-9]{1,3}\.[0-9]{1,3}' | head -n1)

printf "\n\n\n%*s\n\n\n" $(((${#MESSAGE}+$COLUMNS)/2)) "$MESSAGE"
printf "%*s\n" $(($COLUMNS-5)) "d4nse"
printf "%*s\n" $(($COLUMNS-5)) "$PRIVATEIP"

