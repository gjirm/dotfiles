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

UBUNTU_VERSION=$(lsb_release -sr)

echo -e "${LGREEN}--> Bootstraping Starship prompt with ZSH shell ${WHITE}"

SYSTEM_PROFILE=$HOME/.dotfiles/linux/starship

sudo apt update
sudo apt install curl wget git file build-essential zsh autojump -y
#sudo apt instal fd-find

echo -e "${LGREEN}--> Installing Starship ...${WHITE}"
# Install oh-my-zsh
sh -c "$(curl -fsSL https://starship.rs/install.sh)" --

# plugin zsh-syntax-highlighting
echo -e "${LGREEN}--> Installing zsh-syntax-highlighting ...${WHITE}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting

echo -e "${LGREEN}--> Installing zsh-autosuggestions ...${WHITE}"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions

echo -e "${LGREEN}--> Installing Fzf ...${WHITE}"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-fish

echo -e "${LGREEN}--> Installing Fd search...${WHITE}"
if [[ "$UBUNTU_VERSION" == "16.04" || "$UBUNTU_VERSION" == "16.10" || "$UBUNTU_VERSION" == "17.04" || "$UBUNTU_VERSION" == "17.10" || "$UBUNTU_VERSION" == "18.04" || "$UBUNTU_VERSION" == "18.10" ]]
then
  fddeb=$(basename $(curl -s https://api.github.com/repos/sharkdp/fd/releases | grep "browser_download_url.*fd_.*amd64.deb" | cut -d : -f 2,3 | tr -d \" | head -n 1))
  curl -s https://api.github.com/repos/sharkdp/fd/releases | grep "browser_download_url.*fd_.*amd64.deb"  | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O $fddeb -i -
  sudo dpkg -i $fddeb
else
  sudo apt install fd-find
  [[ -f $HOME/.zshrc_local ]] || touch $HOME/.zshrc_local 
  echo "alias fd=fdfind" >> $HOME/.zshrc_local
fi

echo -e "${LGREEN}--> Installing Micro editor...${WHITE}"
app_exists "/usr/local/bin/micro"
arch=$(uname -m)
if [[ "$arch" == "aarch64" ]]
then
  arch="arm64"
elif [[ "$arch" == "x86_64" ]]
then
  arch="linux64"
fi
microfile=$(basename $(curl -s https://api.github.com/repos/zyedidia/micro/releases | grep "browser_download_url.*$arch.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1))
echo -e "${LGREEN}--> Downloading $microfile...${WHITE}"
mkdir micro-tmp
curl -s https://api.github.com/repos/zyedidia/micro/releases | grep "browser_download_url.*$arch.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | tar -xzf - --strip-components=1 -C ./micro-tmp
cmd_check "Micro download" $?
sudo mv "micro-tmp/micro" /usr/local/bin/micro
rm -rf "micro-tmp/"
sudo chmod +x /usr/local/bin/micro
/usr/local/bin/micro --version
install_check "Micro" $?

echo -e "${LGREEN}--> Changing shell to zsh...${WHITE}"
sudo chsh -s /usr/bin/zsh $USER

source ./create-symlinks-starship.sh
source ./create-my-env-vars.sh

#echo -e "${LGREEN}--> Installing basic apps/tools ...${WHITE}"
#source install-tools.sh
