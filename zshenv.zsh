export ABBR_USER_ABBREVIATIONS_FILE="$HOME/.zsh/abbreviations"

# Setup go path
export PATH=$PATH:"$(go env GOPATH)/bin"
# Setup python path
export PATH=$PATH:"/home/dev/.local/bin"
# kubeswitch
export PATH=$PATH:"$HOME/code/kubeswitch/hack/switch/"
# Setup cargo
if [[ -a "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export USER_CONFIG_HOME="$HOME/.config"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export KUSTOMIZE_PLUGIN_HOME="/usr/local/bin/"

export CLOUDSDK_PYTHON_SITEPACKAGES=1

script_dir=${0:a:h}
. "${script_dir}/secret.zshenv.zsh"

export TEST_ENVIRONMENT=dev-ops
export KUBERNETES_BASE_URL=".tradera.service"
