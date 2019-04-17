#!/bin/bash
# This script configures Linux computers to connect to the FollowMePrint service
# Jaret Ludvik, April 2019

echo -e "\u001b[35mHigh Point University Follow Me Print Service Setup"
echo -e "\n\u001b[0mMake sure you're connected to HPU-WiFi!"
sleep 3

echo -e "\nFirst step: Installing SAMBA, CUPS-CLIENT and SMBCLIENT..."

echo -e "This will prompt you for your root/admin password for permission to install...\u001b[0m"
sudo apt-get install samba smbclient cups-client

if dpkg -s samba & dpkg -s smbclient & dpkg -s cups-client #check if they're now/currently installed
then
  echo -e "\n\u001b[32mThe required packages SAMBA, CUPS-CLIENT and SMBCLIENT are installed!\u001b[0m"
else
  echo -e "\u001b[31mThe required packages SAMBA, CUPS-CLIENT and SMBCLIENT are either not installed or not installed properly."
  echo -e "Terminating the printer script! Your settings haven't been changed.\u001b[0m"
  exit 0
fi

sleep 0.5
echo -e "\n\u001b[32mSecond step: Changing Samba workgroup to ACADEME so your computer and the printer are in the same group and can see each other."
sudo sed -i 's/workgroup = .*/workgroup = ACADEME/g' /etc/samba/smb.conf
#put workgroup changing thing here


echo -e "\nThird step: Adding the FollowMePrint printer device!"
#the smb share location for fmp is smb://vprodprnt001.highpoint.edu/FollowMePrint
sudo lpadmin -p HPU-FollowMePrint -E -v smb://vprodprnt001.highpoint.edu/FollowMePrint \
     -m drv:///sample.drv/generic.ppd -L "High Point University" -o auth-info-required=negotiate
sudo lpadmin -d HPU-FollowMePrint
#set that bad boy up as the default generic postscript printer
echo -e "\n\u001b[35mThe printer has been configured! When you initiate a print job, it will ask for your HPU login. If the print service stops working for some reason, run me again to restart FollowMePrint setup.\u001b[0m"
