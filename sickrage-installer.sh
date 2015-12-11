#!/bin/bash
# Script Name: AtoMiC SickRage Installer
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
echo -e $GREEN'AtoMiC SickRage Installer Script'$ENDCOLOR
echo 
echo -e $YELLOW'--->SickRage installation will start soon. Please read the following carefully.'$ENDCOLOR

echo -e '1. The script has been confirmed to work on Ubuntu variants, Mint, and Ubuntu Server.'
echo -e '2. While several testing runs identified no known issues, '$CYAN'www.htpcBeginner.com'$ENDCOLOR' or the authors cannot be held accountable for any problems that might occur due to the script.'
echo -e '3. If you did not run this script with sudo, you maybe asked for your root password during installation.'
echo -e '4. By proceeding you authorize this script to install any relevant packages required to install and configure SickRage.'
echo -e '5. Best used on a clean system (with no previous SickRage install) or after complete removal of previous SickRage installation.'

echo
echo -n 'Type the username of the user you want to run SickRage as and press [ENTER]. Typically, this is your system login name (IMPORTANT! Ensure correct spelling and case): '
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

echo -e $YELLOW'--->Refreshing packages list...'$ENDCOLOR
sudo apt-get update

echo
sleep 1

echo -e $YELLOW'--->Installing prerequisites...'$ENDCOLOR
sudo apt-get -y install git-core python python-cheetah

echo
sleep 1

echo -e $YELLOW'--->Checking for previous versions of SickRage...'$ENDCOLOR
sleep 1
sudo /etc/init.d/sickrage stop >/dev/null 2>&1
echo -e 'Any running SickRage processes stopped'
sleep 1
sudo update-rc.d -f sickrage remove >/dev/null 2>&1
sudo rm /etc/init.d/sickrage >/dev/null 2>&1
sudo rm /etc/default/sickrage >/dev/null 2>&1
echo -e 'Any existing SickRage init scripts removed'
sleep 1
sudo update-rc.d -f sickrage remove >/dev/null 2>&1
if [ -d "/home/$UNAME/.sickrage" ]; then
	mv /home/$UNAME/.sickrage /home/$UNAME/.sickrage_`date '+%m-%d-%Y_%H-%M'` >/dev/null 2>&1
	echo -e 'Existing SickRage files were moved to '$CYAN'/home/'$UNAME'/.sickrage_'`date '+%m-%d-%Y_%H-%M'`$ENDCOLOR
else
	echo -e 'No previous SickRage folder found'
fi

echo
sleep 1

echo -e $YELLOW'--->Downloading latest SickRage...'$ENDCOLOR
cd /home/$UNAME
git clone https://github.com/SiCKRAGETV/SickRage.git /home/$UNAME/.sickrage || { echo -e $RED'Git not found.'$ENDCOLOR ; exit 1; }
sudo chown -R $UNAME:$UGROUP /home/$UNAME/.sickrage >/dev/null 2>&1
sudo chmod 775 -R /home/$UNAME/.sickrage >/dev/null 2>&1

echo
sleep 1

echo -e $YELLOW'--->Installing SickRage...'$ENDCOLOR
cd /home/$UNAME/.sickrage
# Check to see if autoProcessTV.cfg.sample exists https://github.com/htpcBeginner/AtoMiC-ToolKit/issues/29
if [ -f "autoProcessTV/autoProcessTV.cfg.sample" ]; then
 cp -a autoProcessTV/autoProcessTV.cfg.sample autoProcessTV/autoProcessTV.cfg || { echo -e $RED'Could not copy autoProcess.cfg.'$ENDCOLOR ; exit 1; }
fi

echo
sleep 1

echo -e $YELLOW'--->Configuring SickRage Install...'$ENDCOLOR
echo "# COPY THIS FILE TO /etc/default/sickrage" >> sickrage_default || { echo -e $RED'Could not create default file.'$ENDCOLOR ; exit 1; }
echo "SR_HOME=/home/"$UNAME"/.sickrage/" >> sickrage_default
echo "SR_DATA=/home/"$UNAME"/.sickrage/" >> sickrage_default
echo -e 'Enabling user'$CYAN $UNAME $ENDCOLOR'to run SickRage...'
echo "SR_USER="$UNAME >> sickrage_default
sudo mv sickrage_default /etc/default/sickrage

echo
sleep 1

echo -e $YELLOW'--->Enabling SickRage AutoStart at Boot...'$ENDCOLOR
sudo cp runscripts/init.ubuntu /etc/init.d/sickrage || { echo -e $RED'Creating init file failed.'$ENDCOLOR ; exit 1; }
sudo chown $UNAME: /etc/init.d/sickrage
sudo chmod +x /etc/init.d/sickrage
sudo update-rc.d sickrage defaults

echo
sleep 1

echo -e $YELLOW'--->Creating Run Directories...'$ENDCOLOR
sudo mkdir /var/run/sickrage >/dev/null 2>&1
sudo chown $UNAME: /var/run/sickrage >/dev/null 2>&1

echo
sleep 1

echo -e 'Stashing any changes made to SickRage...'
cd /home/$UNAME/.sickrage
git config user.email “atomic@htpcbeginner.com”
git config user.name “AtoMiCUser”
git stash
git stash clear

echo
sleep 1

echo -e 'Starting SickRage...'
/etc/init.d/sickrage start

echo
sleep 1

echo
echo -e $GREEN'--->All done. '$ENDCOLOR
echo -e 'SickRage should start within 10-20 seconds and your browser should open.'
echo -e 'If not you can start it using '$CYAN'/etc/init.d/sickrage start'$ENDCOLOR' command.'
echo -e 'Then open '$CYAN'http://localhost:8081'$ENDCOLOR' in your browser.'
echo
echo -e $YELLOW'If this script worked for you, please visit '$CYAN'http://www.htpcBeginner.com'$YELLOW' and like/follow us.'$ENDCOLOR
echo -e $YELLOW'Thank you for using the AtoMiC SickRage Install script from www.htpcBeginner.com.'$ENDCOLOR 
echo

cd $SCRIPTPATH
sleep 5

exit 0
