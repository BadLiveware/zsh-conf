export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Merging kubeconfigs
function merge_kubeconfigs() {
  export KUBECONFIG=""
  for kubeconfig in $USER_CONFIG_HOME/var/kubeconfig/*; do
    export KUBECONFIG=$KUBECONFIG:"$kubeconfig"
  done
}
merge_kubeconfigs

abbr k="kubectl"
abbr kc="kubectx"
abbr kn="kubens"
abbr kf="kubectl fuzzy"
abbr kd="kubectl run -i --rm --restart=Never debug-pod-$(cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c10 | tr '[:upper:]' '[:lower:]') --image=busybox --annotations="sidecar.istio.io/inject=false" -- sh"
