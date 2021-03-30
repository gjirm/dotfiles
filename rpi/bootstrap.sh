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

# Functions:

app_exists () {
  if [ -f $1 ]
  then
    echo -e "${LBLUE}--> $1 already exists. Updating...${WHITE}"
    rm -f $1
  fi
}
#app_exists "/usr/local/bin/ww"

install_check () {
  if [ $2 -eq 0 ]
  then
    echo -e "${LGREEN}--> $1 installation successfully completed!${WHITE}"
  else
    echo -e "${LRED}--X $1 installation failed. Exiting!${WHITE}"
    exit 1
  fi
}
#install_check "ctop installation" $?

cmd_check () {
  if [ $2 -ne 0 ]
  then
    echo -e "${LRED}--X $1 failed. Exiting!${WHITE}"
    exit 1
  fi
}
#cmd_check "Git clone" $?

# Functions end
#UBUNTU_VERSION=$(lsb_release -sr)

echo -e "${LBLUE}Enter the system profile - personal ${WHITE}"
read SYSTEM_CASE

case $SYSTEM_CASE in

  personal)
    SYSTEM_PROFILE=$HOME/.dotfiles/rpi/personal
    ;;

  *)
    echo -e "${LYELLOW}--! Unknown system type. Exiting...${WHITE}" 
    exit 1
    ;;
esac

sudo apt update
sudo apt install curl wget git file build-essential zsh autojump tmux -y
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

echo -e "${LGREEN}--> Installing Fd search...${WHITE}"
sudo apt install fd-find
[[ -f $HOME/.zshrc_local ]] || touch $HOME/.zshrc_local 
echo "alias fd=fdfind" >> $HOME/.zshrc_local

echo -e "${LGREEN}--> Installing Micro editor...${WHITE}"
app_exists "/usr/local/bin/micro"
microfile=$(basename $(curl -s https://api.github.com/repos/zyedidia/micro/releases | grep "browser_download_url.*arm.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1))
echo -e "${LGREEN}--> Downloading $microfile...${WHITE}"
mkdir micro-tmp
curl -s https://api.github.com/repos/zyedidia/micro/releases | grep "browser_download_url.*arm.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | tar -xzf - --strip-components=1 -C ./micro-tmp
cmd_check "Micro download" $?
sudo mv "micro-tmp/micro" /usr/local/bin/micro
rm -rf "micro-tmp/"
sudo chmod +x /usr/local/bin/micro
/usr/local/bin/micro --version
install_check "Micro" $?

echo -e "${LGREEN}--> Changing shell to zsh...${WHITE}"
sudo chsh -s /usr/bin/zsh $USER

source ./create-symlinks.sh
source ./create-my-env-vars.sh

#echo -e "${LGREEN}--> Installing basic apps/tools ...${WHITE}"
#source install-tools.sh
