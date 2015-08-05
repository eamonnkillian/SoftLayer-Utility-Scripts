#!/bin/bash
#
# Created:	05-August-2015
# Author:	EJK
# Description:
# A short utility script to grab the password of a specific virtual machine on
# IBM SoftLayer using the Python CLI. 
#
# Dependencies:
# 1) Installed SoftLayer CLI with pip
# 2) Set up your API keys for access to SoftLayer
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
# Lets check we have a machine name as argument 1 ... if we don't then
# we need to let the user know they need to add one
#

if [ "$#" -eq 0 ]
   then
      echo "This script needs a server name in SoftLayer to retrieve its password!"
      echo "Please add a server name to the end of the command as its first argument."
      exit 1
fi

#
# Better also check they've not passed two machines or more
#

if [ "$#" -gt 1 ]
   then
      echo "This script only accepts one argument - the machine you want the root password for."
      exit 1
fi

# 
# Now we can run the command and obtain our password from the 
# SoftLayer CLI for the machine we asked for ...
#

MACHINE=`slcli vs detail "$1" --passwords | grep root`
PASSWORD=`echo $MACHINE | awk '{print $3}'`
echo $PASSWORD
