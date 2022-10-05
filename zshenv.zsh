export ABBR_USER_ABBREVIATIONS_FILE="$HOME/.zsh/abbreviations"

# Setup go path
export PATH=$PATH:"$(go env GOPATH)/bin"
# Setup python path
export PATH=$PATH:"/home/dev/.local/bin"
# Setup cargo
if [[ -a "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

export USER_CONFIG_HOME="$HOME/.config"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
