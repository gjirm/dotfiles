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

LINUX_ID=$(cat /etc/os-release | grep "^ID=" | cut -d = -f 2 | tr -d '"')
ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" ]]
then
  MARCH="-arm64"
  A64="arm64"
elif [[ "$ARCH" == "x86_64" ]]
then
  MARCH="64"
  A64="amd64"
fi

echo -e "${LGREEN}--> Bootstraping Starship prompt with ZSH shell ${WHITE}"

SYSTEM_PROFILE=$HOME/.dotfiles/linux/starship

sudo apt update
sudo apt install curl wget git file build-essential bat tree zsh autojump zip unzip -y
#sudo apt instal fd-find

mkdir $HOME/.zsh_completions

echo -e "${LGREEN}--> Installing Starship ...${WHITE}"

# Install starship
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# plugin zsh-syntax-highlighting
echo -e "${LGREEN}--> Installing zsh-syntax-highlighting ...${WHITE}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting

echo -e "${LGREEN}--> Installing zsh-autosuggestions ...${WHITE}"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions

echo -e "${LGREEN}--> Installing Fzf ...${WHITE}"
app_exists "/usr/local/bin/fzf"
durl=$(curl -sL https://api.github.com/repos/junegunn/fzf/releases/latest | grep "browser_download_url.*linux_$A64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1)
file=$(basename $durl)
echo -e "${LGREEN}--> Downloading $file...${WHITE}"
curl -sL $durl | sudo tar -xzf - -C /usr/local/bin
cmd_check "fzf download" $?
sudo chmod +x /usr/local/bin/fzf
/usr/local/bin/fzf --version
install_check "fzf" $?

echo -e "${LGREEN}--> Installing Fd search...${WHITE}"
app_exists "/usr/local/bin/fd"
durl=$(curl -sL https://api.github.com/repos/sharkdp/fd/releases/latest | grep "browser_download_url.*$ARCH-unknown-linux-musl.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1)
file=$(basename $durl)
echo -e "${LGREEN}--> Downloading $file...${WHITE}"
curl -sL $durl | sudo tar -xzf - --strip-components=1 -C /usr/local/bin --wildcards "*/fd"
cmd_check "Fd download" $?
sudo chmod +x /usr/local/bin/fd
/usr/local/bin/fd --version
install_check "Fd" $?

echo -e "${LGREEN}--> Installing Micro editor...${WHITE}"
app_exists "/usr/local/bin/micro"
durl=$(curl -s https://api.github.com/repos/zyedidia/micro/releases | grep -v "nightly" | grep "browser_download_url.*linux$MARCH.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1)
file=$(basename $durl)
echo -e "${LGREEN}--> Downloading $file...${WHITE}"
curl -sL $durl | sudo tar -xzf - --strip-components=1 -C /usr/local/bin/ --wildcards "*/micro"
cmd_check "Micro download" $?
sudo chmod +x /usr/local/bin/micro
/usr/local/bin/micro --version
install_check "Micro" $?

echo -e "${LGREEN}--> Installing Eza ...${WHITE}"
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_$ARCH-unknown-linux-gnu.tar.gz -O - | tar xz
sudo chmod +x eza
sudo chown root:root eza
sudo mv eza /usr/local/bin/eza
/usr/local/bin/eza --version
install_check "Eza" $?

echo -e "${LGREEN}--> Installing Yazi ...${WHITE}"
app_exists "/usr/local/bin/yazi"
durl=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases | grep -v "nightly" | grep "browser_download_url.*yazi-$ARCH-unknown-linux-musl.zip" | cut -d : -f 2,3 | tr -d \" | head -n 1)
file=$(basename $durl)
echo -e "${LGREEN}--> Downloading $file...${WHITE}"
curl -sL $durl -o tmp.zip
cmd_check "Yazi download" $?
unzip -p tmp.zip yazi-$ARCH-unknown-linux-musl/yazi > ./yazi
unzip -p tmp.zip yazi-$ARCH-unknown-linux-musl/ya > ./ya
rm tmp.zip
sudo cp ./yazi /usr/local/bin/yazi
sudo chmod +x /usr/local/bin/yazi
sudo cp ./ya /usr/local/bin/ya
sudo chmod +x /usr/local/bin/ya
rm yazi
rm ya
/usr/local/bin/ya pkg add yazi-rs/plugins:full-border

echo -e "${LGREEN}--> Installing Zoxide ...${WHITE}"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sudo bash -s -- --bin-dir /usr/local/bin

echo -e "${LGREEN}--> Changing shell to zsh...${WHITE}"
sudo chsh -s /usr/bin/zsh $USER

source ./create-symlinks.sh
source ./create-my-env-vars.sh

echo -e "${LGREEN}--> To install mise run: ...${WHITE}"
echo -e "${LBLUE}curl https://mise.run | sh ${WHITE}"
#echo -e "${LGREEN}--> Installing basic apps/tools ...${WHITE}"
#source install-tools.sh
