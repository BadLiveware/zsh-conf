google-projects-fzf() {
  command="gcloud projects list --format='table(project_id,project_number,name)' 2>/dev/null"
  eval $command |
    fzf --height 90% --nth 1 --header-lines 1 \
      --bind "ctrl-r:reload(eval $command)" --header 'CTRL-R to reload / CTRL-S to SSH' --ansi \
      --bind "ctrl-f:preview-half-page-down" \
      --bind "ctrl-b:preview-half-page-up" |
    awk '{print $1}' | xargs -I {} gcloud config set project '{}'
}
alias gpf="google-projects-fzf"

google-ssh-fzf() {
  command="gcloud compute instances list --format='table(name,zone,status)' 2>/dev/null"
  eval $command |
    fzf --height 90% --nth 1 --header-lines 1 \
      --bind "ctrl-r:reload(eval $command)" --header 'Press CTRL-R to reload' |
    awk '{print $1, $2}' | xargs sh -c 'gcloud compute ssh "$0" --zone "$1"'
}
alias gsf="google-ssh-fzf"

google-tail-serial-fzf() {
  command="gcloud compute instances list --format='table(name,zone,status)' 2>/dev/null"
  eval $command |
    fzf --height 90% --nth 1 --header-lines 1 \
      --bind "ctrl-r:reload(eval $command)" --header 'Press CTRL-R to reload' |
    awk '{print $1, $2}' | xargs bash -c 'gcloud compute instances tail-serial-port-output $0 --port=1 --zone $1'
}
alias gtsf="google-tail-serial-fzf"

google-secrets-fzf() {
  gcloud secrets list --project tradera-secrets --format="table[no-heading](name, labels)" | fzf -m | cut -d" " -f1 | xargs -I {} gcloud secrets versions access latest --secret='{}' --project tradera-secrets
}
alias gsecrets="google-secrets-fzf"

# kubectl-get-fzf() {
#   command="kubectl get $* -o custom-columns='NAME:.metadata.name,NAMESPACE:.metadata.namespace' 2>/dev/null"
#   preview_cmd="kubectl get $1 {1} -n {2} -o json 2>/dev/null \
#     | kubectl neat -o yaml \
#     | bat --color=always --language=yaml --style=plain"

#   eval $command |
#     fzf --height 90% --nth 2 --header-lines 1 \
#       --preview "$preview_cmd" \
#       --bind "ctrl-\:execute(kubectl get {+} -o yaml | nvim)" \
#       --bind "ctrl-r:reload(eval $command)" --header 'Press CTRL-R to reload' \
#       --bind "ctrl-]:execute(kubectl edit {+})" \
#       --bind "ctrl-f:preview-half-page-down" \
#       --bind "ctrl-b:preview-half-page-up"
# }
