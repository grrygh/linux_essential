#! /bin/bash

usage() {
  # Display the usage and exit.
  echo
  echo "Usage: ${0} [-vdp]"
  echo 'Linux essential installation'
  echo '  -v  Install VIM application & setup .vimrc'
  echo '  -d  Install Docker application.'
  echo '  -p. Install pihole docker.'
  echo '*If curling from github, add | bash -s -- [-vd]'
  exit 1
}

# Parse the options
while getopts vd OPTION
do
  case ${OPTION} in
    v) VIM='true' ;;
    d) DOCKER='true' ;;
    p) PIHOLE='true' ;;
    ?) usage ;;
  esac
done

# Check for options.
if [[ "${#}" -eq 0 ]]
then
  usage >&2
fi

# Install VIM application & setup .vimrc
if [[ "${VIM}" = 'true' ]]
then
  which vim # Check if VIM is installed.
  if [[ $? -ne 0 ]] # If VIM is not installed.
  then
    echo 'Installing VIM...'
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get install -y vim
  else # If VIM is installed, check for update.
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

# Install Docker application.
if [[ "${DOCKER}" = 'true' ]]
then
  which docker # Check if Docker is installed.
  if [[ $? -ne 0 ]] # If Docker is not installed.
  then
    echo 'Installing Docker...'
    sudo apt-get update && sudo apt-get upgrade
    cd ~
    curl -fsSL https://get.docker.com -o get-docker.sh # Download docker install script.
    sudo sh get-docker.sh
    sudo usermod -aG docker pi # Add pi to Docker group.
    # Install Docker compose.
    sudo apt-get install libffi-dev libssl-dev -o Acquire::ForceIPv4=true
    sudo apt install python3-dev -o Acquire::ForceIPv4=true
    sudo apt-get install -y python3 python3-pip -o Acquire::ForceIPv4=true
    sudo pip3 install docker-compose
  else
    echo 'Docker is already installed.'
  fi
fi

# Install pihole docker.
if [[ "${PIHOLE}" -eq 'true' ]]
then
  # Check for pihole container.
  docker container ls | grep pihole
  if [[ $? -ne 0 ]]
  then
    

exit 0
