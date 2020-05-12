#! /bin/bash

#This script is for raspbian OS.

# Check if VIM is installed.
which vim
if [[ $? -ne 0 ]]
then
  echo 'Installing VIM...'
  sudo apt-get install -y vim
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

wget https://raw.githubusercontent.com/grrygh/linux_essential/master/.vimrc -P ~/

exit 0
