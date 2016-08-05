if [ `uname` == 'Darwin' ]; then
    alias ls='ls -G'
elif [ `uname` == 'Linux' ]; then
    alias ls='ls --color=auto'
fi

alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls -l'

export EDITOR=vim
export PATH=$PATH:~/bin
export PS1='\u@\h:\W `gitbr;echo -ne "\[\x1b]2;\h:${PWD#$HOME/}\[\x7\]"`$ '

export LESSCHARSET=utf-8

### man page colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias glog='git log --oneline --decorate --color --graph'
alias glogc="git log --pretty=format:\"%C(auto)%h %Cgreen%an%Creset %C(auto)%d %s\""

alias gup='git pull --rebase'
