HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/m/.zshrc'

autoload -Uz compinit
compinit
typeset -U PAH
export -U PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/sbin:~/.npm-global

export EDITOR=nvim

# fzf
[[ $- == *i* ]] && source "/home/me/.fzf/shell/completion.zsh" 2> /dev/null
source "/usr/local/Cellar/fzf/0.32.0/shell/key-bindings.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# git
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
#RPROMPT=\$vcs_info_msg_0_
#PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'
git config --global push.default simple
git config --global user.name "LongWuYuan"
git config --global user.email "longwuyuan@gmail.com"
git config --global color.ui true

# Prompt
NEWLINE=$'\n'
PROMPT='%n%"@%m [%~] %S'\$vcs_info_msg_0_'%s$NEWLINE%# '

# AWS Stuff
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/Cellar/awscli/2.6.1/bin/aws_completer' aws

# Kubernetes
source <(kubectl completion zsh)
alias k="kubectl"
complete -F __start_kubectl k
source <(helm completion zsh)
source <(minikube completion zsh)
source <(linkerd completion zsh)
source <(argocd completion zsh)
source <(kind completion zsh)
source <(gh completion -s zsh)

# GCP Stuff
#source /usr/share/google-cloud-sdk/completion.zsh.inc

# Aliases
alias v=vi
alias n=nvim

alias tb="nc termbin.com 9999"
set -o vi

# pnpm
export PNPM_HOME="/Users/m/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Docker
docker context use lima
