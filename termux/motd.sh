#!/data/data/com.termux/files/usr/bin/bash

# Setup TERMUX_APP_PACKAGE_MANAGER
source "/data/data/com.termux/files/usr/bin/termux-setup-package-manager" || exit 1

ARRAY[0]="Your eyes deceive you."
ARRAY[1]="The system needs you."
ARRAY[2]="You are the Operator."
randnum=$(( $RANDOM % 3 ))
MESSAGE="${ARRAY[$randnum]}"

echo -e "



		$MESSAGE



				      danse@nethunter

"
