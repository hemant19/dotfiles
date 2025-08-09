# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export EDITOR=nvim

autoload -U compinit; compinit

if [[ $(uname) == "Darwin" ]]; then
  source $HOME/.zsh/macos.sh
fi

source $HOME/.zsh/plugins/init.sh
source $HOME/.zsh/aliases/init.sh
source $HOME/.zsh/options.sh

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


[[ ! -f $HOME/.p10k.zsh ]] || source ~/.p10k.zsh

# TMUX auto-connect
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ "$TERM" != "dumb" ]; then
    # Get the list of sessions
    sessions=$(tmux list-sessions -F "#S" 2>/dev/null)
    if [ -z "$sessions" ]; then
        # No sessions, create a new one
        tmux new-session -s "main"
    else
        # Attach to the last session
        last_session=$(echo "$sessions" | tail -n 1)
        tmux attach-session -t "$last_session"
    fi
fi


