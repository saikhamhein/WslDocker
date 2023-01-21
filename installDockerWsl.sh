#!/bin/bash

# This script is created with informations 
# from https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

#check for root
if [ $EUID -ne 0 ]
then 
	echo "Please run as root"
	exit
fi

#install necessary packages
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

#Add docker official GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#Set up repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#install docker engine
chmod a+r /etc/apt/keyrings/docker.gpg
apt-get update
apt-get upgrade -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

#add user to docker group to allow non root-level execution
gpasswd -a $SUDO_USER docker

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6) 
echo "wsl.exe -u root -e sh -c 'service docker start'" >> $USER_HOME/.profile
