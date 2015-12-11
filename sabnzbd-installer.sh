#!/bin/bash
# Script Name: AtoMiC SABnzbd Installer
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
echo -e $GREEN'AtoMiC SABnzbd Installer Script'$ENDCOLOR
echo 
echo -e $YELLOW'--->SABnzbd installation will start soon. Please read the following carefully.'$ENDCOLOR

echo -e '1. The script has been confirmed to work on Ubuntu variants, Mint, and Ubuntu Server.'
echo -e '2. While several testing runs identified no known issues, '$CYAN'www.htpcBeginner.com'$ENDCOLOR' or the authors cannot be held accountable for any problems that might occur due to the script.'
echo -e '3. If you did not run this script with sudo, you maybe asked for your root password during installation.'
echo -e '4. By proceeding you authorize this script to install any relevant packages required to install and configure SABnzbd.'
echo -e '5. Best used on a clean system (with no previous SABnzbd install) or after complete removal of previous SABnzbd installation.'

echo
echo -n 'Type the username of the user you want to run SABnzbd as and press [ENTER]. Typically, this is your system login name (IMPORTANT! Ensure correct spelling and case): '
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
sleep 1

echo -e $YELLOW"--->Adding SABnzbd repository..."$ENDCOLOR
GREPOUT=$(grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep jcfp)
if [ "$GREPOUT" == "" ]; then
    sudo add-apt-repository -y ppa:jcfp/ppa
else
    echo "SABnzbd PPA repository already exists..."
fi

echo
sleep 1

echo -e $YELLOW"--->Refreshing packages list..."$ENDCOLOR
sudo apt-get update

echo
sleep 1

echo -e $YELLOW"--->Installing SABnzbd..."$ENDCOLOR
sudo apt-get -y install sabnzbdplus

echo 
sleep 1

echo -e $YELLOW"--->Making some configuration changes..."$ENDCOLOR
sudo sed -i 's/USER=/USER='$UNAME'/g' /etc/default/sabnzbdplus  || { echo -e $RED'Replacing username in default failed.'$ENDCOLOR ; exit 1; }
sudo sed -i 's/HOST=/HOST=0.0.0.0/g' /etc/default/sabnzbdplus  || { echo -e $RED'Replacing host in default failed.'$ENDCOLOR ; exit 1; }
sudo sed -i 's/PORT=/PORT=8080/g' /etc/default/sabnzbdplus || { echo -e $RED'Replacing port in default failed.'$ENDCOLOR ; exit 1; }

echo 
sleep 1

echo -e $YELLOW"--->Enabling autostart during boot..."$ENDCOLOR
sudo update-rc.d sabnzbdplus defaults  >/dev/null 2>&1

echo 
sleep 1

echo -e $YELLOW"--->Starting SABnzbd..."$ENDCOLOR
sudo service sabnzbdplus start >/dev/null 2>&1

sleep 1

echo
echo -e $GREEN'--->All done. '$ENDCOLOR
echo -e 'SABnzbd should start within 10-20 seconds.'
echo -e 'If not you can start it using '$CYAN'sudo service sabnzbdplus start'$ENDCOLOR' command.'
echo -e 'Then open '$CYAN'http://localhost:8080'$ENDCOLOR' in your browser.'
echo
echo -e $YELLOW'If this script worked for you, please visit '$CYAN'http://www.htpcBeginner.com'$YELLOW' and like/follow us.'$ENDCOLOR
echo -e $YELLOW'Thank you for using the AtoMiC Sonarr Install script from www.htpcBeginner.com.'$ENDCOLOR 
echo

cd $SCRIPTPATH
sleep 5

exit 0
