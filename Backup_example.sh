#!/bin/sh
#########################
#   Backup work files   #
#########################

#############################################################
# This script is executed automatically every weekday at 6 pm
# Set up using a cron job (the last field disables mail):
# $ export VISUAL=nano # First change txt editor to use
# $ sudo crontab -e
# 0 18 * * 1-5 bash /Users/luis/Google_Drive_NYU/LabShare_Luis/LabWork/Scripts/Shell_scripts/Backup.sh >/dev/null 2>&1
#
# To see a list of active crontab jobs:
# $ crontab -l
##############


# What to backup
origin='/Users/luis/Google_Drive_NYU/LabShare_Luis/'
origin1='/Users/luis/Google_Drive_NYU/LabShare_Luis/LabBook/'
origin2='/Users/luis/Google_Drive_NYU/LabShare_Luis/LabWork/'

# Where to backup to

#########################################################################
# In order to avoid the need to be connected to server or enter password:
# $ ssh-keygen -t rsa
# # enter for default location and double enter to skip passphrase set up
# # ~/.ssh/ does not exist on server; create it and append key in one step:
# $ cat ~/.ssh/id_rsa.pub | ssh lab@hotspot.bio.nyu.edu "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
# Make sure directory permissions are right on server:
# $ chmod 700 ~/.ssh
# $ chmod 600 ~/.ssh/authorized_keys
##############

#dest="lab@hotspot.bio.nyu.edu:/Users/lab/Desktop/LabShare/Luis"
#dest1="lab@hotspot.bio.nyu.edu:/Users/lab/Desktop/LabShare/Luis/LabBook/"
#dest2="lab@hotspot.bio.nyu.edu:/Users/lab/Desktop/LabShare/Luis/LabWork/"
dest="lab@hotspot.bio.nyu.edu:/Shares/LabShare-2/Luis/"
dest1="lab@hotspot.bio.nyu.edu:/Shares/LabShare-2/Luis/LabBook/"
dest2="lab@hotspot.bio.nyu.edu:/Shares/LabShare-2/Luis/LabWork/"

# Print start status message
echo "---------------------"
echo "     FILE BACKUP"
echo "---------------------"

echo " Backing up:
$origin
to
$dest
"
date
echo

# Backup the files using rsync
rsync -avzi --delete --progress --quiet $origin1 $dest1
rsync -avzi --delete --progress --quiet $origin2 $dest2

# Print end status message.
echo
date
echo
echo "Backup finished!!!"
echo "---------------------"
