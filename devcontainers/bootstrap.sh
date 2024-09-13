#!/bin/bash

LGREEN="\e[1;32m"
LYELLOW="\e[1;33m"
LBLUE="\e[1;34m"
LRED="\e[1;31m"
WHITE="\e[0m"

echo -e "${LGREEN}--> Bootstraping Starship prompt with ZSH shell ${WHITE}"
echo -e "${LGREEN}--> Installing Starship ...${WHITE}"
# Install oh-my-zsh
sh -c "$(curl -fsSL https://starship.rs/install.sh)" --

# plugin zsh-syntax-highlighting
echo -e "${LGREEN}--> Installing zsh-syntax-highlighting ...${WHITE}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting

echo -e "${LGREEN}--> Installing zsh-autosuggestions ...${WHITE}"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions

