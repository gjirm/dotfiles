#!/bin/bash

LGREEN="\e[1;32m"
LYELLOW="\e[1;33m"
LBLUE="\e[1;34m"
LRED="\e[1;31m"
WHITE="\e[0m"

echo -e "${LGREEN}--> Bootstraping Starship prompt with ZSH shell ${WHITE}"

mkdir $HOME/.zsh_completions

echo -e "${LGREEN}--> Installing apps ${WHITE}"

apps=(
    "starship"
    "fzf"
    "fd"
    "micro"
)

for app in ${apps[@]}
do
    curl -sSL https://go.jirm.cz/u/$app | bash
done

echo -e "${LGREEN}--> Configure environments ${WHITE}"

# zshrc
curl -sSL https://raw.githubusercontent.com/gjirm/dotfiles/refs/heads/master/devcontainers/.zshrc -o $HOME/.zshrc

# zsh plugins
echo -e "${LGREEN}--> Installing zsh-syntax-highlighting ...${WHITE}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting

echo -e "${LGREEN}--> Installing zsh-autosuggestions ...${WHITE}"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions

# micro config
[[ -d $HOME/.config/micro ]] || mkdir -p $HOME/.config/micro
curl -sSL https://raw.githubusercontent.com/gjirm/dotfiles/refs/heads/master/devcontainers/.config/micro/settings.json -o $HOME/.config/micro/settings.json

# starship config
curl -sSL https://raw.githubusercontent.com/gjirm/dotfiles/refs/heads/master/devcontainers/.config/starship.toml -o $HOME/.config/starship.toml
sed -i "s/-->PROJECT<--/$PRJ/g" "$HOME/.config/starship.toml"

# yazi config
# [[ -d $HOME/.config/yazi ]] || mkdir -p $HOME/.config/yazi
# curl -sSL https://raw.githubusercontent.com/gjirm/dotfiles/refs/heads/master/devcontainers/.config/yazi/init.lua -o $HOME/.config/yazi/init.lua
# curl -sSL https://raw.githubusercontent.com/gjirm/dotfiles/refs/heads/master/devcontainers/.config/yazi/keymap.toml -o $HOME/.config/yazi/keymap.toml
# curl -sSL https://raw.githubusercontent.com/gjirm/dotfiles/refs/heads/master/devcontainers/.config/yazi/yazi.toml -o $HOME/.config/yazi/yazi.toml

# /usr/local/bin/ya pack -a yazi-rs/plugins:full-border