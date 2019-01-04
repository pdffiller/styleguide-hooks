#!/bin/bash

# This is a general-purpose function to ask Yes/No questions in Bash, either
# with or without a default answer. It keeps repeating the question until it
# gets a valid answer.

# Import functions
. .git/hooks/color_echo.sh


# Import settings
. .git/hooks/_default_settings.sh

if [ -f .git/hooks/_user_defined_settings.sh ]; then
    . .git/hooks/_user_defined_settings.sh
fi

function ask () {
    ### Params ###
    MSG=$1
    DEFAULT_ANSWER=$2
    # Params end #

    # https://gist.github.com/davejamesmiller/1965569
    local prompt default reply

    if [ "${DEFAULT_ANSWER:-}" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "${DEFAULT_ANSWER:-}" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        color_echo "${COLOR_WARNING}" "${MSG} [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read -r reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}
