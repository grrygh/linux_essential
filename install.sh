#! /bin/bash

ls ~/.vimrc &> /dev/null

# Check if .vimrc file is already there, then delete it.
if [[ $? -eq 0 ]]
then
  rm ~/.vimrc
fi

wget https://raw.githubusercontent.com/grrygh/linux_essential/master/.vimrc -P ~/

exit 0
