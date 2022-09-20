config_path=`dirname $0`
my_modules="$config_path/modules"
my_plugins="$config_path/plugins"
my_features="$config_path/features"
fpath=( $config_path $my_modules $my_features $my_plugins $my_plugins/zsh-completions/src $my_plugins/pure $fpath )

source $my_plugins/powerlevel10k/powerlevel10k.zsh-theme
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# autoload -U promptinit && promptinit
# prompt pure

autoload -U compinit
compinit

setopt autocd
setopt extendedglob
setopt NO_NOMATCH

export CLICOLOR=1
#
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export FZF_DEFAULT_OPTS="\
--height 40% \
--reverse \
--border \
--color border:255 \
--cycle"

export DISPLAY=:0
export BROWSER=/usr/bin/wslview

function update_go_tools() {
  packages=(
    github.com/dty1er/kubecolor/cmd/kubecolor
  )

    for pkg in $packages; do
        echo "$pkg"
        go get -u $pkg
    done
}

ABBR_DEFAULT_BINDINGS=0
source $my_plugins/ohmyzsh/plugins/vi-mode/vi-mode.plugin.zsh
source $my_plugins/zsh-abbr/zsh-abbr.zsh
source $my_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source $my_features/ssh-agent.zsh
source $my_plugins/ohmyzsh/plugins/ssh-agent/ssh-agent.plugin.zsh

source $my_modules/keys.zsh
source $my_modules/completion.zsh
source $my_modules/aliases.zsh
source $my_modules/correction.zsh
source $my_modules/stack.zsh
source $my_modules/edit-cmd-line.zsh
source $my_modules/abbreviations.zsh
source $my_features/history.zsh
source $my_features/fasd.zsh
source $my_features/zoxide.zsh
source $my_features/direnv.zsh
source $my_features/thefuck.zsh
source $my_features/nvm.zsh
source $my_features/kubernetes.zsh

# https://gist.github.com/magicdude4eva/2d4748f8ef3e6bf7b1591964c201c1ab
### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $my_features/p10k.zsh ]] || source $my_features/p10k.zsh

# Has to be sourced last
source $my_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
