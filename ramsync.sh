#!/bin/bash

### By: Argon3x
### Supported: Debian Based Systems
### Version: 2.0

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

  # Flushing the kernel page cache and the inode and dentry object cache.
  echo -e "${box} ${yellow}Clearing the cache${end}\c";
  for c in $(seq 1 3); do
    command sudo echo $c > /proc/sys/vm/drop_caches
    if [[ $? -eq 0 ]]; then
      echo -e "....\c"
      if [[ ${c} -eq 3 ]]; then
        echo -e "${green} done ${end}"
      fi
    else
      echo -e "${red} failed ${end}"
      error_handler "An Error Ocurred While Clearing The Cache"
    fi
  done
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

# Clearing the function and variables
sleep 1
unset -f clean_cache_ram
unset red green blue purple yellow end
