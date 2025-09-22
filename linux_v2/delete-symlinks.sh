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

echo -e "${LGREEN}--> Deleting symlinks ${WHITE}"

rm -f $HOME/.config/micro/settings.json
rm -f $HOME/.config/yazi/keymap.toml
rm -f $HOME/.config/yazi/init.lua
rm -f $HOME/.config/yazi/yazi.toml
rm -f $HOME/.config/atuin/config.toml
rm -f $HOME/.config/starship.toml
rm -f $HOME/.config/tmux/tmux.conf
rm -f $HOME/.zshrc
rm -f $HOME/.zsh/.zshrc
rm -f $HOME/.aliases
rm -f $HOME/.env
rm -f $HOME/.vimrc