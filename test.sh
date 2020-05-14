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

# Check for root access
if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run the script as root or sudo.' >&2
  exit 1
fi

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
fi

# Check if Docker is install & update.
if [[ "${DOCKER}" = 'true' ]]
then
  echo 'Display from Docker section.'
fi

exit 0
