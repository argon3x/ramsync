#!/bin/bash

# By: Argon3x
# Supported: Debian Based Systems
# Version: 2.1.0

# Colors
red="\e[01;31m"; green="\e[01;32m"; blue="\e[01;34m"
purple="\e[01;35m"; yellow="\e[01;33m"; end="\e[00m"

# Context box
box="${purple}[${green}+${purple}]${end}"

# Signal Interrupt and Error
interrupt_handler(){
  echo -e "\n${blue}>>>> ${red}Process Canceled ${blue}<<<<${end}\n"
  tput cnorm
  exit 1
}

error_handler(){
  local type_error="$1"
  echo -e "${purple}Script Error${end}:{ \n\t${red}${type_error}${end}\n}"
  tput cnorm
  exit 1
}

# Call the signals
trap interrupt_handler SIGINT
trap error_handler SIGTERM

# Clear Ram Memory Cache.
clean_cache_ram(){
  # Synchronize File System
  echo -e "${box} ${yellow}Sinchronizing file system${end}............\c"; sleep 0.5
  command sudo sync
  if [[ $? -eq 0 ]]; then
    echo -e "${green} done ${end}"
  else
    error_handler "An Error Ocurred While Sinchronizing The File System"
  fi

  # Cleaning memory cache an buffer
  echo -e "${box} ${yellow}Clearing the cache${end}\c";

  command sudo sysctl -w vm.drop_caches=3

  if [[ $? -eq 0 ]]; then
    echo -e "${green} done ${end}"
  else
    error_handler "An Error Ocurred While Cleaning Of Cache and Buffer"
  fi
}

# Checking Execution As Root
if [[ $(id -u) -eq 0 ]]; then
  tput civis && clear
  echo -e "${box} ${yellow}Freeing up RAM${end}..........."; sleep 1
  # Clean Cache Ram Function.
  clean_cache_ram

  tput cnorm
else
  error_handler "use: ${green}sudo ./${0##*/}${end}"
fi
