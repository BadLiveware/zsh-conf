export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Merging kubeconfigs
function merge_kubeconfigs() {
  export KUBECONFIG=""
  for kubeconfig in $USER_CONFIG_HOME/var/kubeconfig/*; do
    export KUBECONFIG=$KUBECONFIG:"$kubeconfig"
  done
}
merge_kubeconfigs

# https://sbulav.github.io/kubernetes/using-fzf-with-kubectl/
kubectl-get-fzf() {
  cmd='kubectl neat get {} -o yaml \
    | batcat --color=always --language=yaml --style=plain'

  kubectl get $* -o name |
    fzf --height 90% \
      --preview "$cmd" \
      --bind "ctrl-\:execute(kubectl get {+} -o yaml | nvim)" \
      --bind "ctrl-r:reload(kubectl get $* -o name)" --header 'Press CTRL-R to reload' \
      --bind "ctrl-]:execute(kubectl edit {+})" \
      --bind "ctrl-f:preview-half-page-down" \
      --bind "ctrl-b:preview-half-page-up"
}
kubectl-get-all-fzf() {
  kubectl get-all $* -o name 2>/dev/null |
    fzf --height 90% --ansi \
      --preview 'sleep 0.2;kubectl neat get {} -o yaml | batcat --color=always --language=yaml --style=plain' \
      --bind "ctrl-\:execute(kubectl get {+} -o yaml | nvim )" \
      --bind "ctrl-r:reload(kubectl get-all $* -o name 2> /dev/null)" --header 'Press CTRL-R to reload' \
      --bind "ctrl-f:preview-half-page-down" \
      --bind "ctrl-b:preview-half-page-up" \
      --bind "ctrl-]:execute(kubectl edit {+})"
}

abbr k="kubectl"
abbr kc="kubectx"
abbr kn="kubens"
abbr kf="kubectl fuzzy"
abbr kd="kubectl run -i --rm --restart=Never debug-pod-$(cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c10 | tr '[:upper:]' '[:lower:]') --image=busybox --annotations="sidecar.istio.io/inject=false" -- sh"
alias kgf="kubectl-get-fzf"
alias kgaf="kubectl-get-all-fzf"

source <(kubectl completion zsh)
compdef kubecolor=kubectl
