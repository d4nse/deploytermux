#!/bin/bash

function print_usage {
    echo "Usage: ${0} [OPTION ...] [FILE]..."
}

function print_help {
    print_usage
    echo "'tarrify' uses GNU 'tar' to save many files into their own individual archives, while typing less."
    echo
    echo "Examples:"
    echo "    tarrify foo bar    # Creates archive foo.tar out of foo and bar.tar out of bar."
    echo "    tarrify -v foo bar # Does the same but verbosely"
    echo
    echo "Options:"
    echo "    -v    # Enables verbose mode. If 'pv' is installed this mode will use it."
    
}

function printout {
    local MESSAGE="$1"
    if [[ "$VERBOSE" -eq 0 ]];
    then
        echo "${MESSAGE}"
    fi
}

function gotta_tar_em_all {
    for file in "${@}"; do
        printout "Packing up $file..."
        command tar --create --file "$file.tar" "$file"
    done
    printout "Done!"
}

function tar_em_with_style {
    for file in "${@}"; do
        printout "Packing up $file..."
        command tar --create --file - "$file" | pv > "$file.tar"
    done
    printout "Done!"
}

# Initiate variables
VERBOSE=1
PVCHECK=1

# Process options
while getopts ':vh' OPTION; do 
    case "$OPTION" in 
        v)
            VERBOSE=0
            if command -v >&- "pv"; then
                PVCHECK=0
            fi
            ;;
        h)
            print_help
            exit 0
            ;;
        ?)
            echo "Invalid option: -${OPTARG}"
            print_usage
            exit 1
            ;;
    esac
done

# Remove options from args
shift $((OPTIND - 1))

# Check if input is empty
if [[ "$#" -eq 0 ]]; then
    echo "Input is empty."
    print_usage
    exit 1
fi

# Validate files
printout "${0}: Validating input..."
FILES=()
for item in "${@}"; do
    if [[ -e "${item}" ]]; then
        FILES+=("${item}")
    else
        echo "'${item}' doesn't exist, skipping"
    fi
done

# Check if validation failed
if [[ "${#FILES[@]}" -eq 0 ]]; then
    echo "Provided files do not exist in the current directory, exiting..."
    exit 1
fi

# Do the thing
printout "Starting..."
if [[ "$PVCHECK" -eq 1 ]]; then
    gotta_tar_em_all "${FILES[@]}"
else
    tar_em_with_style "${FILES[@]}"
fi

exit 0
