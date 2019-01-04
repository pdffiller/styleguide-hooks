#!/bin/bash

# function color echo
# parameters $1 - color should be one of
#   Black, Dark_Gray, Red, Light_Red, Green, Light_Green, Brown,
#   Orange, Yellow, Blue, Light_Blue, Purple, Light_Purple, Cyan,
#   Light_Cyan, Light_Gray, White
# all other parameters - message

function color_echo () {
    local MESSAGE COLOR="$1"
    shift

    case ${COLOR} in
        Black) color="\033[0;0;30m" ;;
        Dark_Gray) color="\033[0;1;30m" ;;
        Red) color="\033[0;0;31m" ;;
        Light_Red) color="\033[0;1;31m"  ;;
        Green) color="\033[0;0;32m" ;;
        Light_Green) color="\033[0;1;32m" ;;
        Brown) color="\033[0;0;33m" ;;
        Orange) color="\033[0;0;33m" ;;
        Yellow) color="\033[0;1;33m" ;;
        Blue) color="\033[0;0;34m" ;;
        Light_Blue) color="\033[0;1;34m" ;;
        Purple) color="\033[0;0;35m" ;;
        Light_Purple) color="\033[0;1;35m" ;;
        Cyan) color="\033[0;0;36m" ;;
        Light_Cyan) color="\033[0;1;36m" ;;
        Light_Gray) color="\033[0;0;37m" ;;
        White) color="\033[0;1;37m" ;;
        *) color="\033[0m" ;;
    esac

    local msg=""; for MESSAGE ; do msg="${msg} $MESSAGE"; done
    echo -e "${color}${msg}\033[0m"
}
