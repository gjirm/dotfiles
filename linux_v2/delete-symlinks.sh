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

# Array of symlink paths
symlinks=(
    "$HOME/.config/micro/settings.json"
    "$HOME/.config/yazi/keymap.toml"
    "$HOME/.config/yazi/init.lua"
    "$HOME/.config/yazi/yazi.toml"
    "$HOME/.config/atuin/config.toml"
    "$HOME/.config/starship.toml"
    "$HOME/.config/tmux/tmux.conf"
    "$HOME/.zshrc"
    "$HOME/.zsh/.zshrc"
    "$HOME/.aliases"
    "$HOME/.env"
    "$HOME/.vimrc"
)

# Loop through each symlink and remove if it exists
for symlink in "${symlinks[@]}"; do
    if [[ -L "$symlink" ]]; then
        echo -e "${LGREEN}--> Removing symlink: $symlink ${WHITE}"
        rm -i "$symlink"  # Use -i for confirmation before deletion
    else
        echo -e "${LYELLOW}--! $symlink is not a symlink or does not exist.${WHITE}"
    fi
done


