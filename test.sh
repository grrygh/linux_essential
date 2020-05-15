#! /bin/bash

usage() {
  # Display the usage and exit.
  echo
  echo "Usage: ${0} [-vd]"
  echo 'Linux essential installation'
  echo '  -v  Install latest VIM & setup .vimrc'
  echo '  -d  Check if docker is install.'
  exit 1
}

# Parse the options
while getopts vd OPTION
do
  case ${OPTION} in
    v) VIM='true' ;;
    d) DOCKER='true' ;;
    ?) usage ;;
  esac
done

# Check for options.
if [[ "${#}" -eq 0 ]]
then
  usage >&2
fi

# Check if VIM is install & Update.
if [[ "${VIM}" = 'true' ]]
then
  echo 'Display from VIM section.'
  which vim
  if [[ $? -ne 0 ]]
  then
    echo 'Installing VIM...'
    sudo apt-get install -y vim
  else
    echo 'Check for VIM update...'
    sudo apt-get update && sudo apt-get install --only-upgrade vim
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
fi

# Check if Docker is install & update.
if [[ "${DOCKER}" = 'true' ]]
then
  echo 'Display from Docker section.'
fi

exit 0
