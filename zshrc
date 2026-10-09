# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/me/.zshrc'

# invoke brew env before compinit as per brew's docs
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

autoload -U bashcompinit && bashcompinit
autoload -Uz compinit && compinit 
# End of lines added by compinstall
typeset -U PATH
export -U PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/go/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/share/google-cloud-sdk/bin

export EDITOR=vim

# fzf
[[ $- == *i* ]] && source "/home/me/.fzf/shell/completion.zsh" 2> /dev/null
source "/usr/share/doc/fzf/examples/key-bindings.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# git
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
#RPROMPT=\$vcs_info_msg_0_
#PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':completion:*:*:git:*' script   /usr/share/doc/git/contrib/completion/git-completion.zsh
git config --global push.default simple
git config --global color.ui true

# Prompt
NEWLINE=$'\n'
export PS1="%{$(tput setaf 34)%}[%{$(tput setaf 34)%}%n%{$(tput setaf 34)%}@%{$(tput setaf 40)%}%m]%{$(tput setaf 46 )%}(%2~)%{$(tput setaf 39)%} '\$vcs_info_msg_0_'%{$(tput sgr0)%}$NEWLINE%# "

# Termbin stuff
alias tb="nc termbin.com 9999"

#for f in `ls $HOME/.completions` ; do source $HOME/.completions/$f ; done
# Brew managed software related stuff
source /home/linuxbrew/.linuxbrew/share/google-cloud-sdk/completion.zsh.inc
complete -C '$HOME/../linuxbrew/.linuxbrew/bin/aws_completer' aws
## brew Kubectl
alias k="kubectl"
complete -F __start_kubectl k
## Brew terraform/opentofu
complete -o nospace -C /home/linuxbrew/.linuxbrew/Cellar/opentofu/1.12.5/bin/tofu tofu
complete -o nospace -C /home/linuxbrew/.linuxbrew/Cellar/opentofu/1.12.5/bin/tofu terraform
