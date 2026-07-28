#!/bin/zsh
# Pick a project and switch to its tmux session, creating it if needed.
#
# Invoked from the `ts` shell function and from the tmux `prefix + f` binding.
# This is the single implementation -- don't reintroduce a copy.

emulate -L zsh
setopt local_options null_glob

workspace="$HOME/workspace"

# tmux treats '.' as a target separator, so it can't appear in a session name.
to_session_name() { print -r -- "${${1:t}//./_}" }

# A new project session gets the same three windows every time. Naming a window
# at creation pins the name, so these survive automatic-rename.
create_session() {
  local name=$1 dir=$2
  tmux new-session -ds "$name" -c "$dir" -n claude
  tmux new-window -d -t "$name:" -c "$dir" -n nvim nvim
  tmux new-window -d -t "$name:" -c "$dir" -n shell
}

attach_or_switch() {
  local name=$1
  if [[ -z ${TMUX:-} ]]; then
    tmux attach -t "$name"
  else
    tmux switch-client -t "$name"
  fi
}

# An explicit argument is always a directory path.
if [[ $# -eq 1 ]]; then
  selected=${1:a}
  [[ -d $selected ]] || { print -u2 "no such directory: $1"; exit 1 }
  name=$(to_session_name "$selected")
  tmux has-session -t="$name" 2>/dev/null || create_session "$name" "$selected"
  attach_or_switch "$name"
  exit 0
fi

# Otherwise offer live sessions first, then the projects without one. Lines are
# marker<TAB>name<TAB>path; fzf shows the first two and previews the third.
typeset -a entries
typeset -A live

if session_list=$(tmux list-sessions -F $'#{session_name}\t#{session_path}' 2>/dev/null); then
  for line in ${(f)session_list}; do
    live[${line%%$'\t'*}]=1
    entries+=( $'●\t'"$line" )
  done
fi

for dir in $workspace/*(/N); do
  name=$(to_session_name "$dir")
  (( ${+live[$name]} )) || entries+=( $'○\t'"$name"$'\t'"$dir" )
done

(( ${#entries} )) || exit 0

selected=$(print -rl -- $entries | fzf --tmux \
  --delimiter=$'\t' --with-nth=1,2 --nth=2 \
  --header='● live session   ○ project' \
  --preview='git -C {3} log --oneline --color=always -12 2>/dev/null || ls -A {3}' \
  --preview-window='right,55%,border-left')

[[ -n $selected ]] || exit 0

IFS=$'\t' read -r marker name dir <<< "$selected"

tmux has-session -t="$name" 2>/dev/null || create_session "$name" "$dir"
attach_or_switch "$name"
