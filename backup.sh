#!/usr/bin/env bash

#-------------------------------------------------------------------------------
#                         ____             __             
#                        / __ )____ ______/ /____  ______   
#                       / __  / __ `/ ___/ //_/ / / / __ \
#                      / /_/ / /_/ / /__/ ,< / /_/ / /_/ /
#                     /_____/\__,_/\___/_/|_|\__,_/ .___/ 
#                                                /_/      
#-------------------------------------------------------------------------------
#
# Description:
#   Backup files from a source to a destination directory.
#
# Depends on:
#  rsync
#
# Luis Vale Silva • https://github.com/luisvalesilva
#-------------------------------------------------------------------------------

SCRIPTNAME=$(basename "${0}")
VERSION=0.1.0
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMAND=rsync

main() {
    # Were the required options provided?
    check_input_arg "'-s|--source'" ${SRC}
    check_input_arg "'-d|--destination'" ${DEST}
    
    # Do the directories exist?
    check_input_dir ${SRC}
    check_input_dir ${DEST}
    
    if [ ${QUIET} = "off" ]; then
        echo "--------------------------------------------------------------"
        echo "                        FILE BACKUP"
        echo "--------------------------------------------------------------"
        echo
    fi

    # Dry run?
    [ ${DRY} = 'on' ] && COMMAND="${COMMAND} --dry-run"
    [[ ${DRY} = 'on' && ${QUIET} = 'off' ]] && echo "Starting dry run..." && echo
    
    [ ${QUIET} = 'on' ] && COMMAND="${COMMAND} --quiet"

    [ ${QUIET} = off ] && echo "Backing up:
    $(realpath $SRC)
            to
    $(realpath $DEST)
    "
    # Backup the files using rsync
    ${COMMAND} -avzi --delete $SRC $DEST 
    
    if [ ${QUIET} = "off" ]; then
        echo 
        echo "Completed backup!"
        echo "--------------------------------------------------------------"
    fi
}

#- Print usage -----------------------------------------------------------------
# Print usage
help_menu() {
    printf "
--------------------------------------------------------------
                        FILE BACKUP
--------------------------------------------------------------

Usage: ${SCRIPTNAME} [-n|--dry-run] [-s SRC_DIR] [-d DEST_DIR]

Backup files in source directory on destination directory.

 Options:
  -s, --source          Path to source directory
  -d, --destination     Path to destination directory
  -n, --dry-run         Show what would have been transferred
                        (rsync's namesake option)
  -q, --quiet           Suppress non-error messages
                        (rsync's namesake option; useful when invoking from cron)
  -h, --help            Display this help menu and exit
      --version         Print version information and exit

"
}

#- Parse arguments (using straight bash; no getopts)----------------------------
# Print usage if called with no options
if [ $# -lt 1 ]
then
    echo
    help_menu
    exit 0
fi

# Parse arguments
DRY=off
QUIET=off

while [[ $# -gt 0 ]]
do
    case "$1" in
        -h|--help)
            help_menu; exit 0;;
        --version)
            echo "${SCRIPTNAME} ${VERSION}"; exit 0;;
        -s|--source)
            SRC="$2"
            if [ -z ${SRC} ]
            then
                echo >&2 "${SCRIPTNAME} ERROR: Argument '$1' requires a value"
                exit 1
            fi
            shift;;
        -d|--destination)
            DEST="$2"
            if [ -z ${DEST} ]
            then
                echo >&2 "${SCRIPTNAME} ERROR: Argument '$1' requires a value"
                exit 1
            fi
            shift;;
        -n|--dry-run)
            DRY=on;;
        -q|--quiet)
            QUIET=on;;
        -*)
            echo >&2 \
            "${SCRIPTNAME} ERROR: Illegal option '$1'"
            exit 1;;
    esac
    shift
done

#- Helper functions ------------------------------------------------------------
check_input_arg() {
    if [ -z "${2+x}" ]
    then
        echo >&2 "${SCRIPTNAME} ERROR: "$1" is a required argument"
        exit 1
    fi
}

check_input_dir() {
    if [ ! -d "$1" ]
    then
        echo >&2 "${SCRIPTNAME} ERROR: "$1" directory not found"
        exit 1
    fi
}

#- Run main function -----------------------------------------------------------
main
