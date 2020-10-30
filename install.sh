#!/bin/bash

LGREEN="\e[1;32m"
LYELLOW="\e[1;33m"
LBLUE="\e[1;34m"
LRED="\e[1;31m"
WHITE="\e[0m"

if [[ $EUID -e 0 ]]; then
   echo "This script must NOT be run as root" 
   exit 1
fi

echo -e "${LBLUE}Enter the system type - local / server / wsl ${WHITE}"
read SYSTEM_CASE

case $SYSTEM_CASE in

  local)
    SYSTEM_TYPE=$HOME/dotfiles/local
    ;;

  server)
    SYSTEM_TYPE=$HOME/dotfiles/server
    ;;

  wsl)
    SYSTEM_TYPE=$HOME/dotfiles/wsl
    ;;

  *)
    echo -e "${LYELLOW}--! Unknown system type. Exiting...${WHITE}" 
    exit 1
    ;;
esac

sudo apt install curl wget git zsh autojump 

echo -e "${LGREEN}--> Installing oh-my-zsh ...${WHITE}"
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# plugin zsh-syntax-highlighting
echo -e "${LGREEN}--> Installing zsh-syntax-highlighting ...${WHITE}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo -e "${LGREEN}--> Installing zsh-autosuggestions ...${WHITE}"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install powerlevel10K prompt
echo -e "${LGREEN}--> Installing powerlevel10K prompt ...${WHITE}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
#sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k/powerlevel10k"/g' ~/.zshrc

echo -e "${LGREEN}--> Backup original dot files to ${HOME}/.backup/ ${WHITE}"
mkdir $HOME/.backup

[[ -f $HOME/.aliases ]] && mv $HOME/.aliases $HOME/.backup/.aliases

[[ -f $HOME/.env ]] && mv $HOME/.env $HOME/.backup/.env

[[ -f $HOME/.gitconfig ]] && mv $HOME/.gitconfig $HOME/.backup/.gitconfig

[[ -f $HOME/.p10k.zsh ]] && mv $HOME/.p10k.zsh $HOME/.backup/.p10k.zsh

[[ -f $HOME/.tmux.conf ]] && mv $HOME/.tmux.conf $HOME/.backup/.tmux.conf

[[ -f $HOME/.zshrc ]] && mv $HOME/.zshrc $HOME/.backup/.zshrc

echo -e "${LGREEN}--> Setting up dot files ...${WHITE}"

# Micro editor settings
mkdir -p $HOME/.config/micro
ln -s $SYSTEM_TYPE/.config/micro/settings.json $HOME/.config/micro/settings.

ln -s $SYSTEM_TYPE/.aliases $HOME/.aliases
ln -s $SYSTEM_TYPE/.env $HOME/.env
ln -s $SYSTEM_TYPE/.gitconfig $HOME/.gitconfig
ln -s $SYSTEM_TYPE/.p10k.zsh $HOME/.p10k.zsh
ln -s $SYSTEM_TYPE/.tmux.conf $HOME/.tmux.conf
ln -s $SYSTEM_TYPE/.zshrc $HOME/.zshrc

echo -e "${LGREEN}--> Changing shell to zsh...${WHITE}"

sudo chsh -s /usr/bin/zsh $USER

echo -e "${LGREEN}--> Finished <--${WHITE}"
#echo -e "${LGREEN}--> Installing basic apps/tools ...${WHITE}"
#source install-tools.sh

