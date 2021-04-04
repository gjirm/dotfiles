#!/bin/bash
#
# Script for installing/updating some handy tools for backup, encryption, cli etc.
# - golang
# - webwormhole
# - minio-client
# - azcopy
# - age
# - restic
# - ctop
# - step
# - gocryptfs
#
# Author: JirM
#
# Bash strict mode
#   http://redsymbol.net/articles/unofficial-bash-strict-mode/
# set -euo pipefail
# IFS=$'\n\t'

LGREEN="\e[1;32m"
LYELLOW="\e[1;33m"
LBLUE="\e[1;34m"
LRED="\e[1;31m"
WHITE="\e[0m"

if [ $EUID -ne 0 ]
then
   echo -e "${LYELLOW}--! This script needs to be run as root!${WHITE}" 
   exit 1
fi

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

#apt install curl wget git

# micro
echo -e "${LGREEN}--> Installing Micro editor...${WHITE}"
app_exists "/usr/local/bin/micro"
microfile=$(basename $(curl -s https://api.github.com/repos/zyedidia/micro/releases | grep "browser_download_url.*linux64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1))
echo -e "${LGREEN}--> Downloading $microfile...${WHITE}"
mkdir micro-tmp
curl -s https://api.github.com/repos/zyedidia/micro/releases | grep "browser_download_url.*linux64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | tar -xzf - --strip-components=1 -C ./micro-tmp
cmd_check "Micro download" $?
mv "micro-tmp/micro" /usr/local/bin/micro
rm -rf "micro-tmp/"
chmod +x /usr/local/bin/micro
/usr/local/bin/micro --version
install_check "Micro" $?

# Go
echo -e "${LGREEN}--> Installing Go...${WHITE}"
git clone https://github.com/udhos/update-golang
cmd_check "Git clone" $?
cd update-golang
./update-golang.sh
cmd_check "Golang install" $?
cd ..
rm -rf update-golang

# WebWormhole
echo -e "${LGREEN}--> Installing WebWormhole...${WHITE}"
app_exists "/usr/local/bin/ww"
git clone https://github.com/saljam/webwormhole
cmd_check "Go clone" $?
cd webwormhole
/usr/local/go/bin/go mod download
cmd_check "Go mod download" $?
/usr/local/go/bin/go build -o /usr/local/bin/ww ./cmd/ww
cmd_check "WebWormhole build" $?
chmod +x /usr/local/bin/ww
cd ..
rm -rf webwormhole

/usr/local/bin/ww

if [ $? -eq 2 ]
then
  echo -e "${LGREEN}--> Webwormhole installation successfully completed!${WHITE}"
else
  echo -e "${LRED}--X Webwormhole installation failed. Exiting!${WHITE}"
  exit 1
fi

# Minio-client
echo -e "${LGREEN}--> Installing minio-client...${WHITE}"
app_exists "/usr/local/bin/mc"
curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
cmd_check "Minio-client download" $?
chmod +x /usr/local/bin/mc

# Setup S2 Minio-Client config
# if [ ! -f /etc/minio/client/config.json ]; then
#     echo -e "${LBLUE}--> Creating minio-client config file: /etc/minio/client/config.yml${WHITE}"
#     echo "Input AWS S3 ACCESS_KEY:"
#     read ACCESS_KEY
#     echo "Input AWS S3 SECRET_KEY:"
#     read SECRET_KEY
#     mkdir -p /etc/minio/client
# cat >> /etc/minio/client/config.json <<EOF
# {
# 	"version": "10",
# 	"hosts": {
# 		"gcs": {
# 			"url": "https://storage.googleapis.com",
# 			"accessKey": "YOUR-ACCESS-KEY-HERE",
# 			"secretKey": "YOUR-SECRET-KEY-HERE",
# 			"api": "S3v2",
# 			"path": "dns"
# 		},
# 		"local": {
# 			"url": "http://localhost:9000",
# 			"accessKey": "",
# 			"secretKey": "",
# 			"api": "S3v4",
# 			"path": "auto"
# 		},
# 		"play": {
# 			"url": "https://play.min.io",
# 			"accessKey": "Q3AM3UQ867SPQQA43P2F",
# 			"secretKey": "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG",
# 			"api": "S3v4",
# 			"path": "auto"
# 		},
# 		"s3": {
# 			"url": "https://s3.amazonaws.com",
# 			"accessKey": $ACCESS_KEY,
# 			"secretKey": $SECRET_KEY,
# 			"api": "S3v4",
# 			"path": "dns"
# 		}
# 	}
# }
# EOF
# fi
/usr/local/bin/mc -v
install_check "Minio-client" $?

# AzCopy
echo -e "${LGREEN}--> Installing azcopy v10...${WHITE}"
app_exists "/usr/local/bin/azcopy"
wget -q -O - https://aka.ms/downloadazcopy-v10-linux | tar -xzf - --strip-components=1 -C /usr/local/bin
cmd_check "AzCopy download" $?
chmod +x /usr/local/bin/azcopy
chown root:root /usr/local/bin/azcopy
/usr/local/bin/azcopy --version
install_check "AzCopy" $?

# Age
echo -e "${LGREEN}--> Installing age encryption...${WHITE}"
app_exists "/usr/local/bin/age"
agefile=$(basename $(curl -s https://api.github.com/repos/FiloSottile/age/releases | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1))
echo -e "${LGREEN}--> Downloading $agefile...${WHITE}"
curl -s https://api.github.com/repos/FiloSottile/age/releases | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | tar -xzf - --strip-components=1 -C /usr/local/bin
cmd_check "Age download" $?
chmod +x /usr/local/bin/age
chown root:root /usr/local/bin/age
chmod +x /usr/local/bin/age-keygen
chown root:root /usr/local/bin/age-keygen
/usr/local/bin/age -version
install_check "Age" $?

# Rage
echo -e "${LGREEN}--> Installing rage encryption...${WHITE}"
app_exists "/usr/local/bin/rage"
ragefile=$(basename $(curl -s https://api.github.com/repos/str4d/rage/releases | grep "browser_download_url.*x86_64-linux.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1))
echo -e "${LGREEN}--> Downloading $ragefile...${WHITE}"
curl -s https://api.github.com/repos/str4d/rage/releases | grep "browser_download_url.*x86_64-linux.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | tar -xzf - --strip-components=1 -C /usr/local/bin
cmd_check "Rage download" $?
/usr/local/bin/rage --version
install_check "Rage" $?

# if [ $? -eq 0 ]
# then
#   echo -e "${LGREEN}--> Rage installation successfully completed!${WHITE}"
# else
#   echo -e "${LRED}--X Rage installation failed. Exiting!${WHITE}"
#   exit 1
# fi

# Restic
# echo -e "${LGREEN}--> Installing restic backup...${WHITE}"
# app_exists "/usr/local/bin/restic"
# curl -s https://api.github.com/repos/restic/restic/releases | grep "browser_download_url.*linux_amd64.bz2" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | bzip2 -df > /usr/local/bin/restic
# cmd_check "Restic download" $?
# chmod +x /usr/local/bin/restic
# chown root:root /usr/local/bin/restic
# /usr/local/bin/restic version
# install_check "Restic" $?

# ctop
echo -e "${LGREEN}--> Installing ctop utility...${WHITE}"
app_exists "/usr/local/bin/ctop"
curl -s https://api.github.com/repos/bcicen/ctop/releases | grep "browser_download_url.*linux-amd64" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O /usr/local/bin/ctop -i -
cmd_check "Ctop download" $?
chmod +x /usr/local/bin/ctop
chown root:root /usr/local/bin/ctop
/usr/local/bin/ctop -v
install_check "Ctop" $?

# step cli: https://github.com/smallstep/cli
echo -e "${LGREEN}--> Installing Step CLI utility...${WHITE}"
app_exists "/usr/local/bin/step"
curl -s https://api.github.com/repos/smallstep/cli/releases | grep "browser_download_url.*linux.*amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | tar -xzf - --strip-components=2 -C /usr/local/bin
cmd_check "Step CLI download" $?
chmod +x /usr/local/bin/step
chown root:root /usr/local/bin/step
/usr/local/bin/step version
install_check "Step" $?

# gocryptfs: https://github.com/rfjakob/gocryptfs
echo -e "${LGREEN}--> Installing gocryptfs...${WHITE}"
apt install fuse
curl -s https://api.github.com/repos/rfjakob/gocryptfs/releases | grep "browser_download_url.*linux-static_amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | grep -v beta | head -n 1 | wget -q -O - -i - | tar -xzpf - -C /usr/local/bin
cmd_check "gocryptfs download" $?
/usr/local/bin/gocryptfs -version
install_check "gocryptfs" $?

# taskctl
echo -e "${LGREEN}--> Installing taskctl...${WHITE}"
app_exists "/usr/local/bin/taskctl"
taskctlfile=$(basename $(curl -s https://api.github.com/repos/taskctl/taskctl/releases | grep "browser_download_url.*linux.*amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1))
echo -e "${LGREEN}--> Downloading $taskctlfile...${WHITE}"
curl -s https://api.github.com/repos/taskctl/taskctl/releases | grep "browser_download_url.*linux.*amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | head -n 1 | wget -q -O - -i - | tar -xzf - taskctl -C /usr/local/bin
cmd_check "taskctl download" $?
chmod +x /usr/local/bin/taskctl
/usr/local/bin/taskctl --version
install_check "taskctl" $?