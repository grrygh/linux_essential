#! /bin/bash

# Version 2.1

usage() {
  # Display the usage and exit.
  echo
  echo "Usage: ${0} [-vdpw]"
  echo 'Linux essential installation'
  echo '  -v  Install VIM application & setup .vimrc'
  echo '  -d  Install Docker application.'
  echo '  -p  Install pihole docker.'
  echo '  -w  Install wireguard docker.'
  echo '*If curling from github, add | bash -s -- [-vdpw]'
  exit 1
}

# Parse the options
while getopts vdpw OPTION
do
  case ${OPTION} in
    v) VIM='true' ;;
    d) DOCKER='true' ;;
    p) PIHOLE='true' ;;
    w) WIREGUARD='true' ;;
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
exit 0

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
exit 0

# Install pihole docker.
if [[ "${PIHOLE}" -eq 'true' ]]
then
  # Check for pihole container.
  docker container ls | grep pihole &> /dev/null
  if [[ $? -ne 0 ]] # If container is missing.
  then
    ls ~/pihole.yml &> /dev/null # Check for pihole.yml file.
    if [[ $? -ne 0 ]] # If pihole.yml is missing.
    then    
      wget https://raw.githubusercontent.com/grrygh/linux_essential/master/pihole.yml -P ~/
      docker-compose -f pihole.yml up -d pihole # Start pihole container.
      wget https://raw.githubusercontent.com/grrygh/linux_essential/master/pihole_gravity.sh -P ~/
    fi
  else
    echo 'Pihole container is implemented.'
    exit 1
  fi
fi
exit 0

# Install wireguard docker.
if [[ "${WIREGUARD}" -eq 'true' ]]
then
  # Check for wireguard container.
  docker container ls | grep wireguard &> /dev/null
  if [[ $? -ne 0 ]] # If container is missing.
  then
    ls ~/wireguard.yml &> /dev/null # Check for wireguard.yml file.
    if [[ $? -ne 0 ]] # If wireguard.yml is missing.
    then
      wget https://raw.githubusercontent.com/grrygh/linux_essential/master/wireguard.yml -P ~/
      docker-compose -f wireguard.yml up -d wireguard # Start wireguard container.
    fi
  else
    echo 'Wireguard container is implemented.'
    exit 1
  fi
fi
exit 0
