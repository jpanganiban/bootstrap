#!/bin/bash
############################################################
# 
# Bootsrap Script
# ===============
# 
# Setups applications from a minimal ubuntu installation.
# 
# Author: Jesse Panganiban
# Version: 0.0.1
#
# TODO
#  * Keep track of bootstrap installed applications
#  * Require sudo to run
#  * Main function
#  * Install base utilities/dependencies
#      (build-essentials, git, etc.)
#  * Install X (Optional)
#  * Install XMonad (Optional)
#  * Clone system configuration repository from github
#    * Create a configuration structure standard
#    * Install configuration
#    * Install applications/configurations (Ala Ruby Bundle)
#      * Can be read from a file (apps.conf)
#  * Set system defaults
#    * ie. text-editor, browser, etc.
#
############################################################

############################################################
#
# Global variables
#
############################################################

DEPENDENCIES="build-essential git-core wget"

LOG_DIR="/tmp"
LOG_FILENAME="bootstrap"
LOG_PATH="${LOG_DIR}/${LOG_FILENAME}.log"
LOG_STDOUT_PATH="/tmp/${LOG_FILENAME}-stdout.log"
LOG_STDERR_PATH="/tmp/${LOG_FILENAME}-stderr.log"

############################################################
#
# Utility functions
#
############################################################

##
# die
# 
# Exits the system with a message.
#
# die <error message>
#
function die {
  printf "$@\n"
  exit 1
}

##
# am_i_root
#
# Checks if the current user is root. Exits if not
#
function am_i_root {
  uid=$(id -u)
  if [ $uid != 0 ]; then
    die "Running bootstrap requires you to be root"
  fi }

##
# log
#
# Prints out a log message
#
# log <message>
#
function log {
  printf "\n[$(whoami): $(date)] $@\n"
}

##
# confirm
#
# Asks the user for a yes or no question (Appends (Y/N))
#
# confirm "Would you like to..? (Y/N)
#
function confirm {
  local question="$@"
  while true; do
    read -p "${question} (Y/N)" choice
    choice=$(echo "${choice}" | awk '{print tolower($0)}')
    case "${choice}" in
      'y')
        return 0
        ;;
      'n')
        return 1
        ;;
      *)
        echo "Invalid selection"
        ;;
    esac
  done
}

##
# confirm_command
# 
# Asks for a confirmation then proceeds when Y/y is entered
# 
# confirm_command <message> [command]
#
function confirm_command {
  local message="$1"; shift
  local command="$@"

  confirm "${message}"
  #[[ $? -eq 0 ]] $command
  [[ $? -eq 0 ]] && $command
}

##
# run_command
#
# Runs a command
# 
# run_command <error message> [command]
#
function run_command {
  local error_message=$1; shift
  local command="$@"

  $command
  [[ $? -ne 0 ]] && die "[ERROR] ${error_message}"
}

##
# run_sudo_command
# 
# Runs a command as sudo
# 
# run_sudo_command <error message> [command]
#
function run_sudo_command {
  local error_message=$1; shift
  local command="$@"

  echo "ERROR MESSAGE: ${error_message}"
  echo "SUDO COMMAND: ${command}"

  run_command "${error_message}" sudo ${command}
}

############################################################
#
# Higher level utility functions
#
############################################################

##
# update_system
#
# Runs an apt-get update && apt-get upgrade to your system
#
function update_system {
  log "Running system update"
  run_sudo_command "Failed to run update" apt-get update
  run_sudo_command "Failed to run upgrade" apt-get upgrade
  log "System update complete!"
}

##
# install_applications
# 
# Installs applications using 'apt-get install'
#
function install_applications {
  applications="$@"
  run_sudo_command "Failed to install ${applications}" apt-get\
    install -y --force-yes "${applications}"
  #log "Installing ${@}"
  #run_sudo_command "Failed to install ${@}" apt-get install "$@"
  #log "Installation complete!"
}

##
# read_args
#
# Parses and reads arguments
#
function read_args {
  die "Unimplemented"
  case "$@" in
  esac
}

##
# main function
#
# Runs the whole script
#
function main {
  am_i_root
  #update_system
  install_applications ${DEPENDENCIES}
}

###########################################################
#
# Let's run it!
#
###########################################################
main
