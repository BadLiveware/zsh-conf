# Utility
alias less='less -R'
alias grep='grep --color=auto'
alias ..='cd ../'

# Kubernetes
alias kubectl=kubecolor

# Git
alias gd='git diff'
alias gco='git checkout'
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias gpp='git pull; git push'
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'

alias magit="emacs \
      --no-window-system \
      --no-init-file \
      --load $USER_CONFIG_HOME/magit/init.el"
      #\ 
      #--eval '(progn (magit-status) (delete-other-windows))'"
