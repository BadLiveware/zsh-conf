ABBR_QUIET=1

abbr g="git"
abbr gs="git status"
abbr ga="git add"
abbr gc="git commit"
abbr gp="git push"
abbr l="lsd -l"
abbr la="lsd -lA"
abbr ll="lsd -lA"

bindkey " " abbr-expand-and-space
bindkey "^M" abbr-expand-and-accept


# ZSH_HIGHLIGHT_REGEXP+=('^[[:blank:][:space:]]*('"${(j:|:)${(k)ABBR_REGULAR_USER_ABBREVIATIONS}}"')$' <styles for regular abbreviations>)
# ZSH_HIGHLIGHT_REGEXP+=('\<('"${(j:|:)${(k)ABBR_GLOBAL_USER_ABBREVIATIONS}}"')$' <styles for global abbreviations>)
