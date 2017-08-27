#!/bin/bash

#------------------------------------------------------------------------------#
#                                 SAM to IGV                                   #
#------------------------------------------------------------------------------#

# Convert SAM file to sorted and indexed BAM file, typically to visualize on IGV


function prep_for_IGV() {
    
    EXT="${1##*.}"
    SAM="$1"
    SAM_NOEXT="${1%.*}"
    SAM_NOPATH=$(basename "$1")
    BAM=${SAM_NOEXT}.bam
    BAM_NOPATH=$(basename "$BAM")
    BAM_NOEXT="${BAM%.*}"
    
    # Check input file: is it a SAM file?
    IN_DIR=$(dirname "$SAM")
    FILE=$(find $IN_DIR -iname "${SAM_NOEXT}.sam")

    if [ -z "$FILE" ]
    then
        echo ">>>>> The input file does not seem to be in SAM format"
        echo "      (no 'sam' or 'SAM' extension). Aborting."
        exit 1
    fi

    # Does "samtools" command work?
    hash samtools 2>/dev/null || \
        { echo >&2 "Could not find samtools. Aborting."; exit 1; }
 
    echo "--------------------------------------------------------------------"
    echo "                      Prepare SAM file for IGV"
    echo "--------------------------------------------------------------------"
    echo
    echo "Converting $SAM_NOPATH to BAM format..."
    samtools view -Sb $SAM > $BAM
    
    echo "Sorting $BAM_NOPATH..."
    samtools sort -o ${BAM_NOEXT}_s.bam -O 'bam' -T 'temp' $BAM

    echo "Indexing ${BAM_NOEXT}_s.bam..."
    samtools index ${BAM_NOEXT}_s.bam

    echo
    echo "Done!"
    echo "--------------------------------------------------------------------"
}

