MOTD=(
    "Your eyes deceive you."
    "And illusion fools you all."
    "The true world revealed."
    "Weaknesses now known to me."
    "Ends all."
    "You die as you lived."
    "Ahem. Gentlemen."
    "The system needs you."
    "You are the Operator."
    "Off to visit your mother!"
)
len=${#MOTD[@]}
index=$((1 + RANDOM % len))
MESSAGE=${MOTD[$index]}

COLUMNS=$(tput cols)
PRIVATEIP=$(ifconfig 2>/dev/null | grep -oE '192\.168\.[0-9]{1,3}\.[0-9]{1,3}' | head -n1)

if echo "$-" | grep i >/dev/null; then
    printf "\n\n%*s\n\n" $(((${#MESSAGE} + $COLUMNS) / 2)) "$MESSAGE"
    printf "%*s\n" $(($COLUMNS - 1)) "d4nse"
    printf "%*s\n" $(($COLUMNS - 1)) "$PRIVATEIP"
fi
