#!/bin/bash
useradd admin
passwd admin <<EOF
testadmin
testadmin
EOF

mkdir /home/admin/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSiVAJyPr7uDIMLc8FeMdw7aFlShd+lYFLTngXeW5rtnRLLsX80IeeUftwmnf4sz9Yz19vUgCza53obCjIxAtwHM6CZvz3xkivF+lBg8yWto65Yoc+13JDn+ERqzAFx1fdXYtf2ARd8AEWSV2LI5iOFLPrHM6cnGAdk3nkkStlb0okyqBxavx3tzxgEyx9QKvEqB/+qMSj2BV/sRxPbzwCks8O9fjUlHrcEXnSsEb6S4+NP1fzMFR4tiy/wDIQTqCTwfcJ3Rb/3LsdlueIpo34XPjlSFVtQ2g2xe/HW93RcdKH3nX0pAM2O9OTXpmE89xxM/0drV8XgHn20pi6GctV saasify@Eamonns-iMac.local" > /home/admin/.ssh/authorized_keys

chown admin /home/admin/.ssh
chmod 700 /home/admin/.ssh

chown admin /home/admin/.ssh/authorized_keys
chmod 600 /home/admin/.ssh/authorized_keys

echo "admin     ALL=(ALL)       NOPASSWD:ALL" >> /etc/sudoers

sed '/PasswordAuthentication yes/d' sshd_config > /tmp/sshd_config
echo "PasswordAuthentication no" >> /tmp/sshd_config
mv /tmp/sshd_config /etc/ssh/sshd_config
chmod 400 /etc/ssh/sshd_config
service sshd restart
