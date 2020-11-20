#!/bin/bash

LGREEN="\e[1;32m"
LYELLOW="\e[1;33m"
LBLUE="\e[1;34m"
LRED="\e[1;31m"
WHITE="\e[0m"

if [[ $EUID -eq 0 ]]
then
   echo "This script must NOT be run as root" 
   exit 1
fi

if [[ -z "$SYSTEM_PROFILE" ]]
then
    echo -e "${LBLUE}Enter the system profile - personal / wsl ${WHITE}"
    read SYSTEM_CASE

    case $SYSTEM_CASE in

    personal)
        SYSTEM_PROFILE=$HOME/.dotfiles/linux/personal
        ;;

    wsl)
        SYSTEM_PROFILE=$HOME/.dotfiles/linux/wsl
        ;;

    *)
        echo -e "${LYELLOW}--! Unknown system type. Exiting...${WHITE}" 
        exit 1
        ;;
    esac
fi

if [ "$SYSTEM_CASE" == "server" ]; then
    echo -e "${LYELLOW}--! Server profile --> skipping and exiting...${WHITE}" 
    exit 1
fi 

[[ -f $HOME/.zshrc_local ]] || touch $HOME/.zshrc_local 

echo -e "${LBLUE}Set ENV variable MY_SSH_PATH ${WHITE}"
read MY_SSH_PATH
[[ -z "$MY_SSH_PATH" ]] || echo "export MY_SSH_PATH='$MY_SSH_PATH'" >> $HOME/.zshrc_local

echo -e "${LBLUE}Set ENV variable MY_WORK_PATH ${WHITE}"
read MY_WORK_PATH
[[ -z "$MY_WORK_PATH" ]] || echo "export MY_WORK_PATH='$MY_WORK_PATH'" >> $HOME/.zshrc_local

echo -e "${LBLUE}Set ENV variable MY_GIT_PATH ${WHITE}"
read MY_GIT_PATH
[[ -z "$MY_GIT_PATH" ]] || echo "export MY_GIT_PATH='$MY_GIT_PATH'" >> $HOME/.zshrc_local

echo -e "${LGREEN}--> Setting variables finished <--${WHITE}"