if [ -z $HISTFILE ]; then
    HISTFILE=$HOME/.zsh_history
fi
HISTSIZE=100000
SAVEHIST=100000
HISTCONTROL=ignoredups

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

# do nothing if fzf is not installed
(( ! $+commands[fzf] )) && return

fzf_history_search() {
  setopt extendedglob
  candidates=(${(f)"$(fc -li -1 0 | fzf +s +m -x -e -q "$BUFFER")"})
  local ret=$?
  if [ -n "$candidates" ]; then
    BUFFER="${candidates[@]/(#m)*/${${(As: :)MATCH}[4,-1]}}"
    BUFFER="${BUFFER[@]/(#b)(?)\\n/$match[1]
}"
    zle vi-fetch-history -n $BUFFER
  fi
  zle reset-prompt
  return $ret
}

autoload fzf_history_search
zle -N fzf_history_search

bindkey "^r" fzf_history_search
