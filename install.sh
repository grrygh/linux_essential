#! /bin/bash

#This script is for raspbian OS.

# Check for root access.
if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run the script with sudo.' >&2
  exit 1
fi

# Check if VIM is installed.
which vim
if [[ $? -ne 0 ]]
then
  echo 'Installing VIM...'
  apt-get install -y vim
else
  echo 'Check for VIM update...'
  apt-get update && sudo apt-get install --only-upgrade vim
fi

# Set default editor to VIM.
if [[ -z "${EDITOR}" ]]
then
  export EDITOR=vim
  echo 'export EDITOR=vim' >> ~/.bashrc
fi

# Check if .vimrc file is already there, then delete it.
ls ~/.vimrc &> /dev/null
if [[ $? -eq 0 ]]
then
  rm ~/.vimrc
fi

wget https://raw.githubusercontent.com/grrygh/linux_essential/master/.vimrc -P /home/pi/

exit 0
