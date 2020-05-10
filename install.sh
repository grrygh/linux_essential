#! /bin/bash

ls ~/.vimrc &> /dev/null
if [[ $? -eq 0 ]]
then
  rm ~/.vimrc
fi
wget -O https://raw.githubusercontent.com/grrygh/linux_essential/master/.vimrc -P ~/
