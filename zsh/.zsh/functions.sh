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

# Pick a project and switch to its tmux session, creating it if needed.
# sesh does the work; how a session is laid out lives in ~/.config/sesh/sesh.toml
# and nowhere else. tmux's `prefix + f` is the same thing from inside tmux.
function ts() {
  if ! command -v sesh &>/dev/null; then
    print -u2 "ts: sesh is not installed -- brew install sesh"
    return 1
  fi

  # With an argument, connect straight to it. Without one, fuzzy-pick.
  if (( $# )); then
    sesh connect "$@"
    return
  fi

  # Same pipeline as tmux's `prefix + f`; -d collapses the duplicate entry a
  # configured project also gets from zoxide.
  local picked
  picked=$(sesh list -d --icons | fzf --ansi --no-sort \
    --border-label=' sesh ' --prompt='⚡  ' \
    --preview='sesh preview {2..}' \
    --preview-window='right,55%,border-left') || return
  [[ -n $picked ]] || return
  sesh connect "$picked"
}
