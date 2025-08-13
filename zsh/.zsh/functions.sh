# TMUX auto-connect
# Check if tmux is installed, not already in a tmux session, and the shell is interactive
function tm() {
  if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
    # Get the list of sessions
    sessions=$(tmux list-sessions -F "#S" 2>/dev/null)
    if [ -z "$sessions" ]; then
      # No sessions, create a new one called "main"
      tmux new-session -s "main"
    else
      # Attach to the last session in the list
      last_session=$(echo "$sessions" | tail -n 1)
      tmux attach-session -t "$last_session"
    fi
  fi
}

function ts() {
  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(find ~/workspace -mindepth 1 -maxdepth 1 -type d | fzf)
  fi

  if [[ -z $selected ]]; then
    exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)
  tmux_running=$(pgrep tmux)

  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
  fi

  if ! tmux has-session -t=$selected_name 2>/dev/null; then
    tmux new-session -ds $selected_name -c $selected
  fi

  if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
  else
    tmux switch-client -t $selected_name
  fi
}
