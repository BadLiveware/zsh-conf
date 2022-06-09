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
  preview_cmd="kubectl neat get -- $1 {1} -n {2} -oyaml \
    | bat --color=always --language=yaml --style=plain"

  kubectl get $* -o custom-columns='NAME:.metadata.name,NAMESPACE:.metadata.namespace' |
    fzf --height 90% --nth 2 --header-lines 1 \
      --preview "$preview_cmd" \
      --bind "ctrl-\:execute(kubectl get {+} -o yaml | nvim)" \
      --bind "ctrl-r:reload(kubectl get $* -o name)" --header 'Press CTRL-R to reload' \
      --bind "ctrl-]:execute(kubectl edit {+})" \
      --bind "ctrl-f:preview-half-page-down" \
      --bind "ctrl-b:preview-half-page-up"
}
kubectl-get-all-fzf() {
  kubectl get-all $* -o name 2>/dev/null |
    fzf --height 90% --ansi \
      --multi \
      --preview 'sleep 0.2;kubectl get -o yaml {} | bat --color=always --language=yaml --style=plain' \
      --bind "ctrl-\:execute(kubectl get {+} -o yaml | nvim )" \
      --bind "ctrl-r:reload(kubectl get-all $* -o name 2> /dev/null)" --header 'Press CTRL-R to reload' \
      --bind "ctrl-f:preview-half-page-down" \
      --bind "ctrl-b:preview-half-page-up" \
      --bind "ctrl-]:execute(kubectl edit {+})"
}

kubectl-logs-fzf() {
  # current_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
  # echo "$current_namespace"
  kubectl get pods $* |
    fzf --height 90% --ansi --info=inline --layout=reverse --header-lines=1 \
      --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
      --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
      --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
      --bind 'enter:execute:kubectl exec -it {1} -- bash > /dev/tty' \
      --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers {1}) > /dev/tty' \
      --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
      --preview-window up:follow \
      --preview 'kubectl logs --follow --all-containers --tail=10000 {1}' "$@"
}

kjq() {
  # FZF_DEFAULT_OPTS=''
  kubectl get $* -o json >/tmp/kgjq.json
  echo '' |
    fzf --height 90% --ansi --info=inline --preview-window=up:95% --print-query \
      --header 'Filter using jq' \
      --preview 'jq -C {q} /tmp/kgjq.json'
  rm /tmp/kgjq.json
}
kdasel() {
  FZF_DEFAULT_OPTS=''
  kubectl get $* -o json >/tmp/kgdasel.json
  echo '' | fzf --print-query --preview 'dasel -f /tmp/kgdasel.json --colour --format --multiple {q}'
  rm /tmp/kgdasel.json
}

abbr k="kubectl"
abbr kc="kubie ctx"
abbr kn="kubie ns"
abbr kf="kubectl fuzzy"
abbr kd="kubectl run -i --rm --restart=Never debug-pod-$(cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c10 | tr '[:upper:]' '[:lower:]') --image=busybox --annotations="sidecar.istio.io/inject=false" -- sh"
alias kgf="kubectl-get-fzf"
alias kgaf="kubectl-get-all-fzf"
alias klf="kubectl-logs-fzf"

source <(kubectl completion zsh)
compdef kubecolor=kubectl
