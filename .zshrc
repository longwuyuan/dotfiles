# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/me/.zshrc'

autoload -U bashcompinit && bashcompinit
autoload -Uz compinit && compinit 
# End of lines added by compinstall
typeset -U PATH
export -U PATH=$PATH:/usr/local/go/bin:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/aws-cli/v2/current/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin
export FPATH=$FPATH:$HOME/.completions

export EDITOR=vim

# fzf
[[ $- == *i* ]] && source "/home/me/.fzf/shell/completion.zsh" 2> /dev/null
source "/usr/share/doc/fzf/examples/key-bindings.zsh"
#source "/usr/share/fzf/shell/key-bindings.zsh"
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
PROMPT='[%~] %S'\$vcs_info_msg_0_'%s$NEWLINE%# '

# AWS Stuff
#source ~/.local/bin/aws_zsh_completer.sh
#source ~/aws/dist/aws_completer

# Kubernetes
alias k="kubectl"
complete -F __start_kubectl k

# Golang stuff
alias tb="nc termbin.com 9999"
export LIBVIRT_DEFAULT_URI='qemu:///system'

# awscli-v2 stuff
complete -C '/usr/local/aws-cli/v2/current/bin/aws_completer' aws

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/share/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/share/google-cloud-sdk/completion.zsh.inc'; fi

export NVIM_APPNAME=nvim-fatih-vimscript
