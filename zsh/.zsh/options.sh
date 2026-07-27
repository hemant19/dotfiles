#!/bin/zsh

# behaviour
setopt no_beep

# usability
setopt auto_cd

# history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

# ui
export TERM=xterm-256color

# fzf opts 

export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--info=inline
--border=rounded
--preview "bat --color=always --style=number --line-range=:500 {}"
--preview-window "right:50%:hidden"
--bind "ctrl-p:toggle-preview"
--bind "ctrl-/:change-preview-window(down:50%)"
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4
--pointer="➤"
--marker="✔"
--tmux
'
