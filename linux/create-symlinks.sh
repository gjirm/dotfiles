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

SYSTEM_PROFILE=$HOME/.dotfiles/linux/starship

echo -e "${LGREEN}--> Backup original dot files to ${HOME}/.backup/ ${WHITE}"

TIMEDATE=$(date "+%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.backup_$TIMEDATE"

mkdir $BACKUP_DIR
[[ -f $HOME/.config/micro/settings.json ]] && mv $HOME/.config/micro/settings.json $BACKUP_DIR/micro_settings.json
[[ -f $HOME/.config/starship.toml ]] && mv $HOME/.config/starship.toml $BACKUP_DIR/starship.toml

[[ -f $HOME/.aliases ]] && mv $HOME/.aliases $BACKUP_DIR/.aliases
[[ -f $HOME/.env ]] && mv $HOME/.env $BACKUP_DIR/.env
[[ -f $HOME/.gitconfig ]] && mv $HOME/.gitconfig $BACKUP_DIR/.gitconfig
[[ -f $HOME/.tmux.conf ]] && mv $HOME/.tmux.conf $BACKUP_DIR/.tmux.conf
[[ -f $HOME/.zshrc ]] && mv $HOME/.zshrc $BACKUP_DIR/.zshrc
[[ -f $HOME/.fzf.zsh ]] && mv $HOME/.fzf.zsh $BACKUP_DIR/.fzf.zsh

echo -e "${LGREEN}--> Setting up dot files ...${WHITE}"

# Micro editor settings
[[ -d $HOME/.config/micro ]] || mkdir -p $HOME/.config/micro

# Yazi file manager settings
[[ -d $HOME/.config/yazi ]] || mkdir -p $HOME/.config/yazi

[[ -f $HOME/.zshrc_local ]] || touch $HOME/.zshrc_local 

ln -s $SYSTEM_PROFILE/.config/micro/settings.json $HOME/.config/micro/settings.json
ln -s $SYSTEM_PROFILE/.config/yazi/keymap.toml $HOME/.config/yazi/keymap.toml
ln -s $SYSTEM_PROFILE/.config/yazi/init.lua $HOME/.config/yazi/init.lua
ln -s $SYSTEM_PROFILE/.config/yazi/yazi.toml $HOME/.config/yazi/yazi.toml
ln -s $SYSTEM_PROFILE/.config/starship.toml $HOME/.config/starship.toml
ln -s $SYSTEM_PROFILE/.aliases $HOME/.aliases
ln -s $SYSTEM_PROFILE/.env $HOME/.env
ln -s $SYSTEM_PROFILE/.gitconfig $HOME/.gitconfig
ln -s $SYSTEM_PROFILE/.tmux.conf $HOME/.tmux.conf
ln -s $SYSTEM_PROFILE/.vimrc $HOME/.vimrc
ln -s $SYSTEM_PROFILE/.zshrc $HOME/.zshrc
ln -s $SYSTEM_PROFILE/.zshrc $HOME/.zsh/.zshrc
ln -s $SYSTEM_PROFILE/.fzf.zsh $HOME/.fzf.zsh

echo -e "${LGREEN}--> Setting symlinks finished <--${WHITE}"