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

echo -e "${LBLUE}Enter the system type - local / server / wsl ${WHITE}"
read SYSTEM_CASE

case $SYSTEM_CASE in

  local)
    SYSTEM_TYPE=$HOME/.dotfiles/local
    ;;

  server)
    SYSTEM_TYPE=$HOME/.dotfiles/server
    ;;

  wsl)
    SYSTEM_TYPE=$HOME/.dotfiles/wsl
    ;;

  *)
    echo -e "${LYELLOW}--! Unknown system type. Exiting...${WHITE}" 
    exit 1
    ;;
esac

echo -e "${LGREEN}--> Backup original dot files to ${HOME}/.backup/ ${WHITE}"

mkdir $HOME/.backup
[[ -f $HOME/.config/micro/settings.json ]] && mv $HOME/.config/micro/settings.json $HOME/.backup/micro_settings.json
[[ -f $HOME/.aliases ]] && mv $HOME/.aliases $HOME/.backup/.aliases
[[ -f $HOME/.env ]] && mv $HOME/.env $HOME/.backup/.env
[[ -f $HOME/.gitconfig ]] && mv $HOME/.gitconfig $HOME/.backup/.gitconfig
[[ -f $HOME/.p10k.zsh ]] && mv $HOME/.p10k.zsh $HOME/.backup/.p10k.zsh
[[ -f $HOME/.tmux.conf ]] && mv $HOME/.tmux.conf $HOME/.backup/.tmux.conf
[[ -f $HOME/.zshrc ]] && mv $HOME/.zshrc $HOME/.backup/.zshrc

echo -e "${LGREEN}--> Setting up dot files ...${WHITE}"

# Micro editor settings
[[ -d $HOME/.config/micro ]] || mkdir -p $HOME/.config/micro

ln -s $SYSTEM_TYPE/.config/micro/settings.json $HOME/.config/micro/settings.json
ln -s $SYSTEM_TYPE/.aliases $HOME/.aliases
ln -s $SYSTEM_TYPE/.env $HOME/.env
ln -s $SYSTEM_TYPE/.gitconfig $HOME/.gitconfig
ln -s $SYSTEM_TYPE/.p10k.zsh $HOME/.p10k.zsh
ln -s $SYSTEM_TYPE/.tmux.conf $HOME/.tmux.conf
ln -s $SYSTEM_TYPE/.zshrc $HOME/.zshrc

echo -e "${LGREEN}--> Finished <--${WHITE}"