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

    # Was an input file provided?
    check_input ${INPUTFILE}
    
    # Prepare fle name variables
    EXT="${1##*.}"
    SAM="$1"
    SAM_NOEXT="${1%.*}"
    SAM_NOPATH=$(basename "$1")
    BAM=${SAM_NOEXT}.bam
    BAM_NOPATH=$(basename "$BAM")
    BAM_NOEXT="${BAM%.*}"

    # Check input file: is it a SAM file?
    check_sam ${SAM} ${SAM_NOEXT}

    # Does "samtools" command work?
    #TODO: check_command not working - does not stop execution
    check_command ${SAMTOOLS}

    echo "Converting ${SAM_NOPATH} to BAM format..."
    ${SAMTOOLS} view -Sb ${SAM} > ${BAM}

    echo "Sorting ${BAM_NOPATH}..."
    ${SAMTOOLS} sort -o ${BAM_NOEXT}_s.bam -O 'bam' -T 'temp' ${BAM}

    echo "Indexing ${BAM_NOEXT}_s.bam..."
    ${SAMTOOLS} index ${BAM_NOEXT}_s.bam

    echo "Done!"
}

#- Print usage -----------------------------------------------------------------
# Print usage
help_menu() {
    printf "${SCRIPTNAME} [-s STR] <input.sam|input.SAM>

Convert SAM file to indexed BAM to visualize with genome browser.

 Options:
  -s, --samtools    Optional path to samtools executable
                    (default is simply "samtools")
  -h, --help        Display this help menu and exit
      --version     Print version information and exit

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
SAMTOOLS=samtools
FLAG=off

while [[ $# -gt 0 ]]
do
    case "$1" in
        -h|--help)
            help_menu; exit 0;;
        --version)
            echo "${SCRIPTNAME} ${VERSION}"; exit 0;;
        -s|--samtools)
            SAMTOOLS="$2"
            if [ -z ${SAMTOOLS} ]
            then
                echo >&2 "${SCRIPTNAME} ERROR: Argument '$1' requires a value"
                exit 1
            fi
            shift;;
        -g)
            FLAG=on;;
        -*)
            echo >&2 \
            "${SCRIPTNAME} ERROR: Illegal option '$1'"
            exit 1;;
        *) break;; # Argument with no "-": kept in variable "$1"
    esac
    shift
done

# Collect input file name; later check it was provided
INPUTFILE=${1}

#- Helper functions ------------------------------------------------------------

check_input() {
    if [ -z "$1" ]
    then
        echo >&2 "${SCRIPTNAME} ERROR: No input file provided"
        exit 1
    fi
}

check_sam() {
    # Check input file: is it a SAM file?
    local IN_DIR=$(dirname "$1")
    local FILE=$(find ${IN_DIR} -iname "${2}.sam")

    if [ -z "${FILE}" ]
    then
        echo >&2 "${SCRIPTNAME} ERROR: '$(basename "${1}")' not found"
        echo >&2 "(or does not include a '.sam' or '.SAM' extension)"
        exit 1
    fi
}

check_command() {
    hash ${1} 2>/dev/null || \
    { echo >&2 "${SCRIPTNAME} ERROR: Could not find ${1}"; exit 1; }
}

#- Run main function -----------------------------------------------------------
main ${INPUTFILE}
