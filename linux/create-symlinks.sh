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

if [ -z ${SYSTEM_PROFILE+x} ]
then
    echo -e "${LBLUE}Two -Enter the system profile - personal / server / wsl ${WHITE}"
    read SYSTEM_CASE

    case $SYSTEM_CASE in

    personal)
        SYSTEM_PROFILE=$HOME/.dotfiles/linux/personal
        ;;

    server)
        SYSTEM_PROFILE=$HOME/.dotfiles/linux/server
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

echo -e "${LGREEN}--> Backup original dot files to ${HOME}/.backup/ ${WHITE}"

TIMEDATE=$(date "+%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.backup_$TIMEDATE"

mkdir $BACKUP_DIR
[[ -f $HOME/.config/micro/settings.json ]] && mv $HOME/.config/micro/settings.json $BACKUP_DIR/micro_settings.json
[[ -f $HOME/.aliases ]] && mv $HOME/.aliases $BACKUP_DIR/.aliases
[[ -f $HOME/.env ]] && mv $HOME/.env $BACKUP_DIR/.env
[[ -f $HOME/.gitconfig ]] && mv $HOME/.gitconfig $BACKUP_DIR/.gitconfig
[[ -f $HOME/.p10k.zsh ]] && mv $HOME/.p10k.zsh $BACKUP_DIR/.p10k.zsh
[[ -f $HOME/.tmux.conf ]] && mv $HOME/.tmux.conf $BACKUP_DIR/.tmux.conf
[[ -f $HOME/.zshrc ]] && mv $HOME/.zshrc $BACKUP_DIR/.zshrc

echo -e "${LGREEN}--> Setting up dot files ...${WHITE}"

# Micro editor settings
[[ -d $HOME/.config/micro ]] || mkdir -p $HOME/.config/micro

ln -s $SYSTEM_PROFILE/.config/micro/settings.json $HOME/.config/micro/settings.json
ln -s $SYSTEM_PROFILE/.aliases $HOME/.aliases
ln -s $SYSTEM_PROFILE/.env $HOME/.env
ln -s $SYSTEM_PROFILE/.gitconfig $HOME/.gitconfig
ln -s $SYSTEM_PROFILE/.p10k.zsh $HOME/.p10k.zsh
ln -s $SYSTEM_PROFILE/.tmux.conf $HOME/.tmux.conf
ln -s $SYSTEM_PROFILE/.zshrc $HOME/.zshrc

echo -e "${LGREEN}--> Finished <--${WHITE}"