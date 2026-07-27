#!/bin/zsh

# Attach to an existing tmux session, or start one called "main".
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

# Pick a project under ~/workspace and switch to its tmux session.
# The real implementation lives in the script, which is also bound to
# `prefix + f` in .tmux.conf -- keep the logic in one place only.
function ts() {
  "$HOME/.zsh/scripts/tmux-sessionizer.sh" "$@"
}
