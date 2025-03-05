jb() {
  issue=$(jira issue list -s"To Do" -s"In Progress" -s"Inbox" -a$(jira me) | fzf --header-lines=1 --multi) 
  if [ -z "$issue" ]; then
    echo "No issue selected"
    return 1
  fi

  if [ $(echo "$issue" | wc -l) -gt 1 ]; then
    id=""
    for i in $(echo "$issue" | awk -F'\t' '{print $2}'); do
      id="${id} & ${i}"
      id="${id# & }"
      branch="${id// & /-}"
      title="${id}"
    done
  else
    id=$(echo "$issue" | awk -F'\t' '{print $2}')
    descr="$(echo "$issue" | awk -F'\t' '{print $3}')"
    branch="${id}-$(echo "$descr" | sed -E 's/[[:space:]]+/-/g; s/[^a-zA-Z0-9_-]//g; s/--+/-/g;')"
    title="${id}: ${descr}"
  fi
  if [ -z "$branch" ]; then
    echo "Branch extraction failed with result: $branch"
    return 1
  fi
  echo "$title"
  echo "Checking out branch $branch"
  git checkout -b "$branch"
  git push \
    -o merge_request.create \
    -o merge_request.remove_source_branch \
    -o merge_request.draft \
    -o merge_request.title="${title}"
}
