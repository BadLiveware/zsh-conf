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

watch-int () {
    IN=2
    case $1 in
        -n)
            IN=$2
            shift 2
            ;;
    esac
    printf '\033c' # clear
    CM="$*"
    LEFT="$(printf 'Every %.1f: %s' $IN $CM)"
    ((PAD = COLUMNS - ${#LEFT}))
    while :
    do
        DT=$(date)
        printf "$LEFT%${PAD}s\n" "$HOST $(date)"
        eval "$CM"
        sleep $IN
        printf '\033c'
    done
}
