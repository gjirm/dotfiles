source $HOME/.env
source $HOME/.aliases
source $HOME/.zshrc_local 

#eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#eval $(/mnt/d/git/keybase/work/apps/weasel-pageant-1.4/weasel-pageant -r)
#export SSH_AUTH_SOCK=/mnt/d/git/keybase/work/apps/wsl-ssh-agent/ssh-agent.sock

# Add fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"
