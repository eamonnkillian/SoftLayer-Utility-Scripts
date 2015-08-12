#!/bin/bash
#
# Created:	12-August-2015
# Author:	EJK
# Description:
# A short script to harden the security of our SoftLayer virtual machines. This script
# can be taken and run manually or can be used directly from your own GitHub as a post 
# install script when machines are created. At present this script only works for 
# CentOS but could be extended easily to accommodate Ubuntu, RedHat or other. The script
# itself carries out the following activities:
# 
# 1) Adds a standard admin or systems administration user to the machine;
# 2) Sets the admin users password;
# 3) Makes a directory '.ssh' in the admin users home directory;
# 4) Add a file 'authorized_keys' with your administration workstations public key;
# 5) Sets the correct permissions;
# 6) Adds the admin user as a sudoer;
# 7) Removes the ability to log in using ssh with a password.
# 
# The effect of this script is to deliver the ability for passwordless login to your new
# virtual machines from your administration workstation and passwordless sudo'ing. This 
# can save extensive amounts of time when your instancing many virtual or bare metal 
# machines on SoftLayer.
#
# Dependencies:
# 1) Generate SSH keys on your administration workstation;
# 2) Add this script as a standard post-install script to SoftLayer;
# 3) Set up your web accessible script - in my case on GitHub the URL is set as:
#
# https://raw.githubusercontent.com/eamonnkillian/SoftLayer-Utility-Scripts/master/sl-postinstall-security.sh
#
# License: MIT
# Copyright (c) 2015 Eamonn Killian, www.eamonnkillian.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is furnished 
# to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# First up we need to add our standard systems administration/devops user
#

useradd sysadm
passwd sysadm <<EOF
7-Lu)ZDwRws~CJmV
7-Lu)ZDwRws~CJmV
EOF

#
# Next we need to add the '.ssh' directory to our new users home directory
#

mkdir /home/sysadm/.ssh

#
# Next we need to add our public key from the key files we generated on our
# administration workstation or the PC, Laptop or Mac your using as your 
# working client machine.
# 

echo ""ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSiVAJyPr7uDIMLc8FeMdw7aFlShd+lYFLTngXeW5rtnRLLsX80IeeUftwmnf4sz9Yz19vUgCza53obCjIxAtwHM6CZvz3xkivF+lBg8yWto65Yoc+13JDn+ERqzAFx1fdXYtf2ARd8AEWSV2LI5iOFLPrHM6cnGAdk3nkkStlb0okyqBxavx3tzxgEyx9QKvEqB/+qMSj2BV/sRxPbzwCks8O9fjUlHrcEXnSsEb6S4+NP1fzMFR4tiy/wDIQTqCTwfcJ3Rb/3LsdlueIpo34XPjlSFVtQ2g2xe/HW93RcdKH3nX0pAM2O9OTXpmE89xxM/0drV8XgHn20pi6GctV saasify@Eamonns-iMac.local" > /home/admin/.ssh/authorized_keys

# 
# Now we need to make sure of the permissions and ownership of our ssh 
# directory and the authorized_keys file.
#

chown sysadm /home/sysadm/.ssh
chown sysadm /home/sysadm/.ssh/authorized_keys
chmod 700 /home/sysadm/.ssh
chmod 400 /home/sysadm/.ssh/authorized_keys

#
# Now we need to add our sysadm user to the sudoers file. In addition we will 
# make sure we don't have to use a password to sudo from the sysadm user.
#

echo "sysadm	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers

# 
# Now we have a new sudoer user and a standard key exchange login we can harden
# the machine to remove the ability for anyone to ssh into our machine using a 
# password at all.
# 

sed '/PasswordAuthentication yes/d' /etc/ssh/sshd_config > /tmp/sshd_config
echo "PasswordAuthentication no" >> /tmp/sshd_config
mv /tmp/sshd_config /etc/ssh/sshd_config
chmod 400 /etc/ssh/sshd_config

#
# Finally we can restart the SSH service
#

service sshd restart



