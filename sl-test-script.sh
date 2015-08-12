#!/bin/bash

useradd sysadm
passwd sysadm <<EOF
sysadm
sysadm
EOF

mkdir /home/sysadm/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJApotnI8z+jw8qIlfmE6HdKrb1SjvXsenAlvhM73DtuQtXnM2Wc3nxi3pAmdWQPsXBmsWaohKu6rXqY8KMEH8eRxEjaVxyi8qOgWVwtXRHvo+l5BHrzETDQSjxAHi98DYAnOx4tx6qhpXNfACepbBh0vzTfhZ6UPff6hpNk9jnm9NS9EC7BRhxz7CJmCdPYfcq0xLV+mnLNemG9z2evEXQytXMvhGw1ekeUViCsgt6ceKbVkKSHRWcIL2De4EE8pCnZyK2Ac33nm4HCF65QJP0QUHrE+9Ga+KJrqfXqLylg17WS70Qk5u6d1jf23gsEltMmH5ckCjfPzsHzaC06SJ saasify@Eamonns-iMac.local" > /home/sysadm/.ssh/authorized_keys

chown sysadm /home/sysadm/.ssh
chown sysadm /home/sysadm/.ssh/authorized_keys
chmod 700 /home/sysadm/.ssh
chmod 400 /home/sysadm/.ssh/authorized_hosts

echo "sysadm	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers

sed '/PasswordAuthentication yes/d' /etc/ssh/sshd_config > /tmp/sshd_config
echo "PasswordAuthentication no" >> /tmp/sshd_config
mv /tmp/sshd_config /etc/ssh/sshd_config
chmod 400 /etc/ssh/sshd_config 

service sshd restart
