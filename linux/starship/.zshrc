export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export ZDOTDIR="$HOME/.zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    
export HISTSIZE=10000     
export SAVEHIST=10000
export EDITOR=micro
export ATUIN_SYNC_ADDRESS=https://atuin.jirm.cz

fpath=(~/.zsh_completions $fpath)

setopt HIST_IGNORE_SPACE

source $HOME/.env
source $HOME/.aliases
source $HOME/.zshrc_local 

# Completition
autoload -U compinit
compinit
zstyle ':completion:*' menu select
#setopt COMPLETE_ALIASES

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# export FZF_DEFAULT_COMMAND='fd -HI -t f -t l'

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"