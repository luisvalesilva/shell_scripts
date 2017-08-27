#!/usr/bin/env bash

#-------------------------------------------------------------------------------
#               _____ ___    __  ___   __           ___________    __
#              / ___//   |  /  |/  /  / /_____     /  _/ ____/ |  / /
#              \__ \/ /| | / /|_/ /  / __/ __ \    / // / __ | | / / 
#             ___/ / ___ |/ /  / /  / /_/ /_/ /  _/ // /_/ / | |/ /  
#            /____/_/  |_/_/  /_/   \__/\____/  /___/\____/  |___/            
#
#-------------------------------------------------------------------------------
#
# Description:
#   Convert SAM file to indexed BAM.
#
# Depends on:
#  samtools
#
# Luis Vale Silva • https://github.com/luisvalesilva
#-------------------------------------------------------------------------------

SCRIPTNAME=$(basename "${0}")
VERSION=0.1.0
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


main() {
    # source_utils
    echo "${ARGVALUE}"
    echo "${FLAG}" 
}

#- Source utilities ------------------------------------------------------------
source_utils() {
    UTILSPATH="${SCRIPTPATH}/lib/utils.sh" # Update path to find utilities

    if [ -f "${UTILSPATH}" ]
    then
        source "${UTILSPATH}"
    else
        echo >&2 "${SCRIPTNAME} ERROR: Could not find utilities file (utils.sh)"
        exit 1
    fi
}

#- Print usage -----------------------------------------------------------------
# Print usage
help_menu() {
    printf "${SCRIPTNAME} [-a INT|STR] [-g]

Convert SAM file to indexed BAM to visualize with genome browser.

 Options:
  -a, --argument    Argument with (required) value
  -g                Argument with no value
  -h, --help        Display this help menu and exit
      --version     Print version information and exit

"
}

#- Parse arguments (using straight bash; no getopts)----------------------------
# Print usage if called with no options
[ $# -lt 1 ] && echo ""; help_menu; exit 0

# Parse arguments
FLAG=off

while [[ $# -gt 0 ]]
do
    case "$1" in
        -h|--help)
            help_menu; exit 0;;
        --version)
            echo "${SCRIPTNAME} ${VERSION}"; exit 0;;
        -a|--argument)
            ARGVALUE="$2"
            if [ -z ${ARGVALUE} ]
            then
                echo >&2 "${SCRIPTNAME} ERROR: Argument '$1' requires a value"
                exit 1
            fi
            shift;;
        -g)
            FLAG=on;;
        -*)
            echo >&2 \
            "${SCRIPTNAME} ERROR: Illegal option '$1'. Please review usage"
            echo
            help_menu
            exit 1;;
        *) break;; # Argument with no "-": kept in variable "$1"
    esac
    shift
done

#- Run main function -----------------------------------------------------------
main 
