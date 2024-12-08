export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export HISTFILE="/workspaces/_data/.zhistory"    
export HISTSIZE=10000     
export SAVEHIST=10000

#export FZF_DEFAULT_COMMAND='fd -HI -t f -t l'

fpath=(~/.zsh_completions $fpath)

# Aliases
alias cls='clear'

alias ls="ls --color=auto --group-directories-first"
alias l="ls -lhF"
alias ll="ls -lahF"
alias ld="ls -lhd */"
alias lld="ls --color=always -lahF | grep --color=never '/$'"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias tmux="tmux -u"

function fcd() {
    cd $(fd -HI -t d $@ . | fzf)
}

function mcd() {
    mkdir -p $1
    cd $1
}

# Editor
function fed() { 
    micro $(fd -HI -t f -t l $@ . | fzf)
}

# Git
function gitpush() {
    git add .
    git commit -m "$*"
    git pull
    git push
}

# Yazi
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Interactively start ssh sessions
function fs() {
    if [ $# -eq 0 ]
    then
        ssh $(cat ~/.ssh/config | grep -E "Host [^*]+" | awk '{ print $2 }' | fzf)
    else
        ssh $(cat ~/.ssh/config | grep -E "Host .*${1}.*" | awk '{ print $2 }' | fzf)
    fi
}

alias g='git'
alias gcl='git clone'
alias ga='git add'
alias gaa='git add .'
alias gs='git status'
alias gss='git status -s'
alias gg='git status'
alias ggg='git status -s'
alias gpull='git pull'
alias pull='git pull'
alias gp='git push'
alias gpush='git push'
alias push='git push'
alias gpp='git pull && git push'
alias gpo='git push origin'
alias gd='git diff'
alias gdd='git diff --cached'
alias gdw='git diff --color-words'
alias gdt='git difftool'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcom='git commit -m'
alias grest='git restore'

# terraform
# ##########
alias tf='terraform'

# systemctl
###########
alias sc='sudo systemctl'
alias scst='sudo systemctl status'

# docker
###########
alias dcpull='docker compose pull'
alias dcup='docker compose up -d'
alias dccup='docker compose --compatibility up -d'
alias dcdown='docker compose down'
alias sdcpull='sudo docker compose pull'
alias sdcup='sudo docker compose up -d'
alias sdccup='sudo docker compose --compatibility up -d'
alias sdcdown='sudo docker compose down'

# ctop - tmux fix
##################
alias ctop='TERM="${TERM/#tmux/screen}" ctop'

# lazydocker
############
alias lzd='lazydocker'

# Completition
autoload -U compinit
compinit
zstyle ':completion:*' menu select
#setopt COMPLETE_ALIASES

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
