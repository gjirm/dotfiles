#!/bin/bash

sudo apt install zsh
sudo apt install autojump

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# plugin zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

mkdir -p "$HOME/.zsh"
wget https://github.com/ChrisTitusTech/zsh/raw/master/.zsh/aliasrc -O ~/.zsh/aliasrc
echo "source $HOME/.zsh/aliasrc" >> ~/.zshrc

sed -i.bak 's/^plugins=.*/plugins=\(git zsh-autosuggestions zsh-syntax-highlighting autojump\)/g' ~/.zshrc

#cp af-magic-jirm.zsh-theme ~/.oh-my-zsh/themes/af-magic-jirm.zsh-theme
#sed -i 's/ZSH_THEME=.*/ZSH_THEME="af-magic-jirm"/g' ~/.zshrc

# Install spaceship prompt
# git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
# sed -i 's/ZSH_THEME=.*/ZSH_THEME="spaceship"/g' ~/.zshrc

# Install powerlevel10K prompt
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k/powerlevel10k"/g' ~/.zshrc


cat >> ~/.zshrc <<EOF
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

#SPACESHIP_TIME_SHOW=false

SPACESHIP_USER_SHOW="always"
SPACESHIP_USER_COLOR="green"

SPACESHIP_HOST_SHOW="always"

SPACESHIP_CHAR_SYMBOL="❱ "

SPACESHIP_DIR_TRUNC=5
SPACESHIP_DIR_TRUNC_PREFIX=".../"

SPACESHIP_HG_SHOW="false"

SPACESHIP_PACKAGE_SHOW="false"
SPACESHIP_NODE_SHOW="false"
SPACESHIP_RUBY_SHOW="false"
SPACESHIP_ELM_SHOW="false"
SPACESHIP_ELIXIR_SHOW="false"
SPACESHIP_XCODE_SHOW_LOCAL="false"
SPACESHIP_SWIFT_SHOW_LOCAL="false"
SPACESHIP_GOLANG_SHOW="false"
SPACESHIP_PHP_SHOW="false"
SPACESHIP_RUST_SHOW="false"
SPACESHIP_HASKELL_SHOW="false"
SPACESHIP_JULIA_SHOW="false"
SPACESHIP_DOCKER_SHOW="false"
SPACESHIP_AWS_SHOW="false"
SPACESHIP_VENV_SHOW="false"
SPACESHIP_CONDA_SHOW="false"
SPACESHIP_PYENV_SHOW="false"
SPACESHIP_DOTNET_SHOW="false"
SPACESHIP_EMBER_SHOW="false"
SPACESHIP_KUBECTL_VERSION_SHOW="false"
SPACESHIP_TERRAFORM_SHOW="false"

EOF


#chsh -s /usr/bin/zsh


