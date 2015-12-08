#!/bin/bash
# Script Name: AtoMiC SickRage Restore Script
# Author: htpcBeginner
# Publisher: http://www.htpcBeginner.com
# License: MIT License (refer to README.md for more details)
#

# DO NOT EDIT ANYTHING UNLESS YOU KNOW WHAT YOU ARE DOING.
YELLOW='\e[93m'
RED='\e[91m'
ENDCOLOR='\033[0m'
CYAN='\e[96m'
GREEN='\e[92m'
SCRIPTPATH=$(pwd)

function pause(){
   read -p "$*"
}

clear
echo 
echo -e $RED
echo -e " ┬ ┬┬ ┬┬ ┬ ┬ ┬┌┬┐┌─┐┌─┐┌┐ ┌─┐┌─┐┬┌┐┌┌┐┌┌─┐┬─┐ ┌─┐┌─┐┌┬┐"
echo -e " │││││││││ ├─┤ │ ├─┘│  ├┴┐├┤ │ ┬│││││││├┤ ├┬┘ │  │ ││││"
echo -e " └┴┘└┴┘└┴┘o┴ ┴ ┴ ┴  └─┘└─┘└─┘└─┘┴┘└┘┘└┘└─┘┴└─o└─┘└─┘┴ ┴"
echo -e $CYAN
echo -e "                __  ___             "
echo -e "  /\ |_ _ |\/|./     | _  _ ||_/.|_ "
echo -e " /--\|_(_)|  ||\__   |(_)(_)|| \||_ "
echo
echo -e $GREEN'AtoMiC SickRage Restore Script'$ENDCOLOR
echo 
echo -e $YELLOW'--->SickRage backup will start soon. Please read the following carefully.'$ENDCOLOR

echo -e '1. The script has been confirmed to work on Ubuntu variants, Mint, and Ubuntu Server.'
echo -e '2. While several testing runs identified no known issues, '$CYAN'www.htpcBeginner.com'$ENDCOLOR' or the authors cannot be held accountable for any problems that might occur due to the script.'
echo -e '3. If you did not run this script with sudo, you maybe asked for your root password during installation.'
echo -e '4. Best used to restore SickRage backed up using AtoMiC ToolKit or '$CYAN'www.htpcBeginner.com'$ENDCOLOR' guides.'
echo -e '5. SickRage should already be installed before restoring library and settings.'

echo
echo -n 'Type the username of the user you run SickRage as and press [ENTER]. Typically, this is your system login name (IMPORTANT! Ensure correct spelling and case): '
read UNAME

if [ ! -d "/home/$UNAME" ] || [ -z "$UNAME" ]; then
	echo -e $RED'Bummer! You may not have entered your username correctly. Exiting now. Please rerun script.'$ENDCOLOR
	echo
	pause 'Press [Enter] key to continue...'
	cd $SCRIPTPATH
	exit 0
fi
UGROUP=($(id -gn $UNAME))

echo

if [ ! -d "/home/$UNAME/.sickrage" ]; 
then
	echo -e $RED'Error! '$CYAN'/home/'$UNAME/'.sickrage'$RED' not found. Ensure that SickRage is installed. Exiting now. Please rerun script.'$ENDCOLOR
	echo
	pause 'Press [Enter] key to continue...'
	cd $SCRIPTPATH
	exit 0
fi

echo

echo -e $YELLOW'--->Stopping SickRage...'$ENDCOLOR
sudo /etc/init.d/sickrage stop >/dev/null 2>&1
sleep 2

echo
sleep 1

echo -e $YELLOW'--->Checking for existing files...'$ENDCOLOR
cd /home/$UNAME
if [ -f "/home/$UNAME/.sickrage/sickbeard.db" ]; then
	mv /home/$UNAME/.sickrage/sickbeard.db /home/$UNAME/.sickrage/sickbeard.db_previous
	echo -e 'Moved existing sickbeard.db to '$CYAN'/home/'$UNAME'/.sickrage/sickbeard.db_previous'$ENDCOLOR
fi

if [ -f "/home/$UNAME/.sickrage/cache.db" ]; then
	mv /home/$UNAME/.sickrage/cache.db /home/$UNAME/.sickrage/cache.db_previous
	echo -e 'Moved existing cache.db to '$CYAN'/home/'$UNAME'/.sickrage/cache.db_previous'$ENDCOLOR
fi

if [ -f "/home/$UNAME/.sickrage/failed.db" ]; then
	mv /home/$UNAME/.sickrage/failed.db /home/$UNAME/.sickrage/failed.db_previous
	echo -e 'Moved existing failed.db to '$CYAN'/home/'$UNAME'/.sickrage/failed.db_previous'$ENDCOLOR
fi

if [ -f "/home/$UNAME/.sickrage/config.ini" ]; then
	mv /home/$UNAME/.sickrage/config.ini /home/$UNAME/.sickrage/config.ini_previous
	echo -e 'Moved existing config.ini to '$CYAN'/home/'$UNAME'/.sickrage/config.ini_previous'$ENDCOLOR
fi

if [ -f "/home/$UNAME/.sickrage/autoProcessTV/autoProcessTV.cfg" ]; then
	mv /home/$UNAME/.sickrage/autoProcessTV/autoProcessTV.cfg /home/$UNAME/.sickrage/autoProcessTV/autoProcessTV.cfg_previous
	echo -e 'Moved existing autoProcessTV.cfg to '$CYAN'/home/'$UNAME'/.sickrage/autoProcessTV/autoProcessTV.cfg_previous'$ENDCOLOR
fi

echo
sleep 1

echo -e $YELLOW'--->Select SickRage backup file to restore...'$ENDCOLOR
echo -e 'In the following file selection box use ARROW or TAB keys to move and SPACE key to select the backup file (with extension '$CYAN'tar.gz'$ENDCOLOR') to restore.'

echo

pause 'Press [Enter] key to continue...'

BFILE=$(dialog --title "Restore SickRage" --stdout --title "Choose backup file to restore. Use TAB or ARROW keys to move and SPACE to select." --fselect /home/$UNAME/ 15 120)

if [ -f $BFILE ] 
then
	if [[ $BFILE == *.tar.gz ]]
	then
		echo -e 'Restoring the following files from: '$CYAN$BFILE$ENDCOLOR
		tar -C / -zxvf $BFILE || { echo -e $RED'Extracting files failed.'$ENDCOLOR ; exit 1; }
		echo
		sleep 1
		/etc/init.d/sickrage start
	else
		echo -e $RED'Error! Selected file is not a backup file with '$CYAN'tar.gz'$RED' extension. Exiting now. Please rerun script.'$ENDCOLOR
		echo
		pause 'Press [Enter] key to continue...'
		cd $SCRIPTPATH
		exit 0
	fi
else
	echo -e $RED'Error! No file selected. Exiting now. Please rerun script.'$ENDCOLOR
	echo
	pause 'Press [Enter] key to continue...'
	cd $SCRIPTPATH
	exit 0
fi 

echo
echo -e $GREEN'--->All done. '$ENDCOLOR
echo -e 'SickRage files restored.'
echo
echo -e $YELLOW'If this script worked for you, please visit '$CYAN'http://www.htpcBeginner.com'$YELLOW' and like/follow us.'$ENDCOLOR
echo -e $YELLOW'Thank you for using the AtoMiC SickRage Restore script from www.htpcBeginner.com.'$ENDCOLOR 
echo

cd $SCRIPTPATH
sleep 5

exit 0
