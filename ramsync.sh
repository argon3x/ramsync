#!/bin/bash

# - COLORS - #
green="\e[01;32m"; red="\e[01;31m"
blue="\e[01;34m"; yellow="\e[01;33m"
purple="\e[01;35m"; end="\e[00m"

function CTRL_C(){
  exit 0
  tput cnorm
}
function terminated(){
  exit 0
  tput cnorm
}
trap CTRL_C INT
trap terminated SIGTERM

function freeing(){
  i=1
  while [[ ${i} -le 3 ]]; do
    echo -e "${yellow}...${end}\c"
    `sudo sync > /dev/null 2>&1 && sudo sysctl -w vm.drop_caches=3 > /dev/null 2>&1`
    if [[ ${?} -ne 0 ]]; then
      echo -e "${red}--------------------${end}"
      echo -e "${red}  An Error Ocurred ${end}"
      echo -e "${red}--------------------${end}"
      terminated
    fi
    sleep 0.5
    i=$[${i}+1]
  done
  echo
}

function currentStat(){
  state_free=$(free --human --giga | grep 'Mem:' | awk '{print $4}')
  state_used=$(free --human --giga | grep 'Mem:' | awk '{print $3}')
  sleep 1  
  echo -e "${purple}FREE ${blue}-> ${green}${state_free} ${purple}USED ${blue}-> ${red}${state_used}"
}


function main(){
  tput civis echo -e "${blue}Checking ${red}RAM ${blue}Memory${yellow}.......${end}"; sleep 1
  echo -e "${blue}Current State ${end}\c"
  currentStat
  echo -e "${blue}Freeing ${red}RAM ${blue}Memory${end}\c"; freeing
  echo -e "${blue}Current State ${end}\c"
  currentStat
  tput cnorm
}


clear
if [[ $(id -u) -eq 0 ]]; then
  main
else
  echo -e "${red}----------------------${end}"
  echo -e "${red} use: ${green}sudo ${0}${end}"
  echo -e "${red}----------------------${end}"
fi
