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

echo -e "${LBLUE}Enter the system profile - personal / server / wsl ${WHITE}"
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

sudo apt install curl wget git file build-essential zsh autojump -y
#sudo apt instal fd-find

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

echo -e "${LGREEN}--> Installing Fzf ...${WHITE}"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-fish

if [[ "$SYSTEM_CASE" != "server" ]]
then
  echo -e "${LGREEN}--> Installing Linuxbrew ...${WHITE}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo -e "${LGREEN}--> Changing shell to zsh...${WHITE}"
sudo chsh -s /usr/bin/zsh $USER

source ./create-symlinks.sh

#echo -e "${LGREEN}--> Installing basic apps/tools ...${WHITE}"
#source install-tools.sh
