#!/bin/bash
# Script Name: AtoMiC SABnzbd Uninstaller
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
echo -e $GREEN'AtoMiC SABnzbd Uninstaller Script'$ENDCOLOR
echo 
echo -e $YELLOW'--->SABnzbd uninstallation will start soon. Please read the following carefully.'$ENDCOLOR

echo -e '1. The script has been confirmed to work on Ubuntu variants, Mint, and Ubuntu Server.'
echo -e '2. While several testing runs identified no known issues, '$CYAN'www.htpcBeginner.com'$ENDCOLOR' or the authors cannot be held accountable for any problems that might occur due to the script.'
echo -e '3. If you did not run this script with sudo, you maybe asked for your root password during installation.'
echo -e '4. By proceeding you authorize this script to uninstall any relevant files/packages.'
echo -e '5. Best used to uninstall SABnzbd installed using AtoMiC ToolKit or '$CYAN'www.htpcBeginner.com'$ENDCOLOR' guides.'

echo
echo -n 'Type the username of the user you installed SickBeard as and press [ENTER]. Typically, this is your system login name (IMPORTANT! Ensure correct spelling and case): '
read UNAME

if [ ! -d "/home/$UNAME" ] || [ -z "$UNAME" ]; then
  echo -e $RED'Bummer! You may not have entered your username correctly. Exiting now. Please rerun script.'$ENDCOLOR
	echo
	pause 'Press [Enter] key to continue...'
	cd $SCRIPTPATH
	exit 0
fi

echo
sleep 1

echo -e $YELLOW'--->Stopping SABnzbd...'$ENDCOLOR
sudo service sabnzbdplus stop >/dev/null 2>&1
sudo killall sabnzbdplus >/dev/null 2>&1

echo
sleep 1

echo -e $YELLOW'--->Uninstalling SABnzbd...'$ENDCOLOR
sudo apt-get -y remove sabnzbdplus*

echo
sleep 1

echo -e $YELLOW'--->Removing SABnzbd Autostart scripts...'$ENDCOLOR
sudo update-rc.d -f sabnzbdplus remove || { echo -e $RED'Warning! update-rc.d remove failed.'$ENDCOLOR ; }
sudo rm /etc/default/sabnzbdplus || { echo -e $RED'Warning! Removing default script failed.'$ENDCOLOR ; }
sudo rm /etc/init.d/sabnzbdplus || { echo -e $RED'Warning! Removing init script failed.'$ENDCOLOR ; }

echo
sleep 1

read -p 'Do you want to keep SABnzbd configuration files in case you want to reinstall later? Type y/Y to keep files or any other key to delete files, and press [ENTER] : '
FILEDEL=${REPLY,,}

if [ "$FILEDEL" != "y" ] 
then
	echo
	echo -e $YELLOW'--->Deleting SABnzbd files from '$CYAN'/home/'$UNAME'/.sabnzbd'$YELLOW'...'$ENDCOLOR
	sudo rm -r /home/$UNAME/.sabnzbd >/dev/null 2>&1
else
	echo
	echo -e $YELLOW'--->Keeping SABnzbd files in '$CYAN'/home/'$UNAME'/.sabnzbd'$YELLOW'...'$ENDCOLOR
fi

echo
sleep 1

echo -e $GREEN'--->All done.'$ENDCOLOR
echo -e 'SABnzbd Uninstalled.'
echo
echo -e $YELLOW'If this script worked for you, please visit '$CYAN'http://www.htpcBeginner.com'$YELLOW' and like/follow us.'$ENDCOLOR
echo -e $YELLOW'Thank you for using the AtoMiC SABnzbd Uninstall script from www.htpcBeginner.com.'$ENDCOLOR 
echo

cd $SCRIPTPATH
sleep 5

exit 0
