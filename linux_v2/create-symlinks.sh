#!/bin/bash

LGREEN="\e[1;32m"
WHITE="\e[0m"

if [[ $EUID -eq 0 ]]; then
   echo "This script must NOT be run as root"
   exit 1
fi

SYSTEM_PROFILE="$HOME/.dotfiles/linux_v2"
TIMEDATE=$(date "+%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.backup_$TIMEDATE"

echo -e "${LGREEN}--> Backup original dot files to ${BACKUP_DIR} ${WHITE}"
mkdir -p "$BACKUP_DIR"

declare -A FILES_TO_BACKUP=(
   ["$HOME/.config/micro/settings.json"]="micro_settings.json"
   ["$HOME/.config/starship.toml"]="starship.toml"
   ["$HOME/.aliases"]=".aliases"
   ["$HOME/.env"]=".env"
   ["$HOME/.gitconfig"]=".gitconfig"
   ["$HOME/.tmux.conf"]=".tmux.conf"
   ["$HOME/.zshrc"]=".zshrc"
   ["$HOME/.fzf.zsh"]=".fzf.zsh"
)

for file in "${!FILES_TO_BACKUP[@]}"; do
   [[ -f "$file" ]] && mv "$file" "$BACKUP_DIR/${FILES_TO_BACKUP[$file]}"
done

echo -e "${LGREEN}--> Setting up dot files ...${WHITE}"

declare -a CONFIG_DIRS=(
   "$HOME/.config/micro"
   "$HOME/.config/yazi"
   "$HOME/.config/atuin"
   "$HOME/.config/tmux"
   "$HOME/.zsh"
)

for dir in "${CONFIG_DIRS[@]}"; do
   mkdir -p "$dir"
done

[[ -f "$HOME/.zshrc_local" ]] || touch "$HOME/.zshrc_local"

declare -A SYMLINKS=(
   ["$SYSTEM_PROFILE/config/micro/settings.json"]="$HOME/.config/micro/settings.json"
   ["$SYSTEM_PROFILE/config/yazi/keymap.toml"]="$HOME/.config/yazi/keymap.toml"
   ["$SYSTEM_PROFILE/config/yazi/init.lua"]="$HOME/.config/yazi/init.lua"
   ["$SYSTEM_PROFILE/config/yazi/yazi.toml"]="$HOME/.config/yazi/yazi.toml"
   ["$SYSTEM_PROFILE/config/atuin/config.toml"]="$HOME/.config/atuin/config.toml"
   ["$SYSTEM_PROFILE/config/starship/starship.toml"]="$HOME/.config/starship.toml"
   ["$SYSTEM_PROFILE/config/tmux/tmux.conf"]="$HOME/.config/tmux/tmux.conf"
   ["$SYSTEM_PROFILE/config/zsh/.zshrc"]="$HOME/.zshrc"
   ["$SYSTEM_PROFILE/config/zsh/.aliases"]="$HOME/.aliases"
   ["$SYSTEM_PROFILE/config/zsh/.env"]="$HOME/.env"
   ["$SYSTEM_PROFILE/config/vim/.vimrc"]="$HOME/.vimrc"
)

for src in "${!SYMLINKS[@]}"; do
   ln -sf "$src" "${SYMLINKS[$src]}"
done

# Create additional symlink for .zshrc to $HOME/.zsh/.zshrc
ln -sf "$SYSTEM_PROFILE/config/zsh/.zshrc" "$HOME/.zsh/.zshrc"
cp "$SYSTEM_PROFILE/config/git/.gitconfig" "$HOME/.gitconfig"

echo -e "${LGREEN}--> Setting symlinks finished <--${WHITE}"
