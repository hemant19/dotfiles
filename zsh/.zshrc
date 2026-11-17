# Interactive Zsh configuration (shared across macOS & Linux / agni).

# ------------------------------------------------------------------------------
# 1. Powerlevel10k Instant Prompt (keep near top; console prompts go above this)
# ------------------------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------------------------
# 2. Core Environment & Cache
# ------------------------------------------------------------------------------
typeset -U path PATH
export LANG=en_US.UTF-8
if (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export VISUAL="$EDITOR"

typeset -g ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# ------------------------------------------------------------------------------
# 3. Shell Options & History
# ------------------------------------------------------------------------------
setopt no_beep
setopt auto_cd
setopt interactive_comments

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

# NOTE: Never export TERM here — Ghostty, WezTerm, and tmux set it properly.

# ------------------------------------------------------------------------------
# 4. Completions (rebuild compdump & security scan at most once every 24h)
# ------------------------------------------------------------------------------
autoload -Uz compinit
_zcompdump="$ZSH_CACHE_DIR/zcompdump-${ZSH_VERSION}"
_zcompdump_fresh=($_zcompdump(N.mh-24))
if (( $#_zcompdump_fresh )); then
  compinit -C -d "$_zcompdump"
else
  compinit -d "$_zcompdump"
fi
unset _zcompdump _zcompdump_fresh

# ------------------------------------------------------------------------------
# 5. Colors, Manpager & FZF Defaults (Catppuccin Mocha)
# ------------------------------------------------------------------------------
if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# Cached vivid LS_COLORS (0ms shell startup)
if (( $+commands[vivid] )); then
  _lscolors_cache="$ZSH_CACHE_DIR/lscolors-catppuccin-mocha.zsh"
  if [[ ! -s "$_lscolors_cache" ]]; then
    print -r -- "export LS_COLORS=${(q)$(vivid generate catppuccin-mocha)}" >| "$_lscolors_cache"
  fi
  source "$_lscolors_cache"
  unset _lscolors_cache
fi

if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
fi

export FZF_DEFAULT_OPTS='
--height 45%
--layout=reverse
--info=inline-right
--border=rounded
--bind "ctrl-p:toggle-preview"
--bind "ctrl-/:change-preview-window(down,50%|hidden|right,55%)"
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4
--pointer="➤"
--marker="✔"
--tmux 80%,70%
'

export FZF_CTRL_T_OPTS='
--preview "if [ -d {} ]; then eza --tree --level=2 --color=always --icons=always {}; else bat --color=always --style=numbers --line-range=:400 {} 2>/dev/null || cat {}; fi"
--preview-window "right,55%,border-left"
'

export FZF_ALT_C_OPTS='
--preview "eza --tree --level=2 --color=always --icons=always {}"
--preview-window "right,55%,border-left"
'

# ------------------------------------------------------------------------------
# 6. Plugins & Shell Integrations
# ------------------------------------------------------------------------------
if [[ -o zle ]]; then
  [[ "${TERM:-}" != "dumb" && -f "$HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme" ]] && \
    source "$HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"

  # fzf-tab must load after compinit, before autosuggestions & syntax highlighting
  [[ -f "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && \
    source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

  [[ -f "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

  (( $+commands[fzf] )) && source <(fzf --zsh)
  (( $+commands[atuin] )) && eval "$(atuin init zsh --disable-up-arrow)"
fi

(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

# ------------------------------------------------------------------------------
# 7. fzf-tab Styling & Contextual Previews
# ------------------------------------------------------------------------------
zstyle ':completion:*' menu no
[[ -n "${LS_COLORS:-}" ]] && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'

if [[ -n "${TMUX:-}" ]]; then
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  zstyle ':fzf-tab:*' popup-min-size 80 16
fi

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always --icons=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --tree --level=2 --color=always --icons=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:(bat|cat|nvim|vim|less|head|tail):*' fzf-preview \
  'if [[ -d $realpath ]]; then eza --tree --level=2 --color=always --icons=always $realpath; else bat --color=always --style=numbers --line-range=:250 $realpath 2>/dev/null; fi'
zstyle ':fzf-tab:complete:(export|unset):*' fzf-preview 'print -r -- ${(P)word}'
zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
  'git log --oneline --graph --date=short --color=always -20 $word 2>/dev/null'

# ------------------------------------------------------------------------------
# 8. Interactive Aliases (scripts & non-interactive `zsh -c` stay unaffected)
# ------------------------------------------------------------------------------
if (( $+commands[eza] )); then
  alias ls='eza --color=auto --group-directories-first --icons=auto'
  alias ll='eza -la --icons=auto --octal-permissions --group-directories-first --color=auto'
  alias l='eza -bGF --header --git --color=auto --group-directories-first --icons=auto'
  alias llm='eza -lbGd --header --git --sort=modified --color=auto --group-directories-first --icons=auto'
  alias la='eza --long --all --group --group-directories-first --icons=auto --color=auto'
  alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=auto --group-directories-first --icons=auto'
  alias lS='eza -1 --color=auto --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --color=auto --group-directories-first --icons=auto'
fi

if (( $+commands[bat] )); then
  alias cat='bat --paging=never'              # Raw plain text when piped
fi
if (( $+functions[__zoxide_z] )); then
  alias z='cd'
  alias zi='cdi'
fi
alias rgh='rg --hyperlink-format=default'   # Clickable OSC-8 file links in Ghostty/WezTerm
alias dft='git dft'                         # Structural AST diff via difftastic

# ------------------------------------------------------------------------------
# 9. Functions (always use `return`, never `exit`)
# ------------------------------------------------------------------------------

# Attach to the most recently used tmux session, or create "main".
function tm() {
  if command -v tmux &>/dev/null && [[ -z "$TMUX" && $- == *i* ]]; then
    if tmux list-sessions &>/dev/null; then
      tmux attach-session
    else
      tmux new-session -s "main"
    fi
  fi
}

# Tmux project/session switcher (tmux sessions + zoxide + ~/workspace).
function ts() {
  if ! command -v tmux &>/dev/null || ! command -v fzf &>/dev/null; then
    print -u2 "ts: requires tmux and fzf"
    return 1
  fi

  local target session_name
  if (( $# )); then
    target="$1"
  else
    target=$(
      {
        tmux list-sessions -F "[tmux] #S" 2>/dev/null
        command -v zoxide &>/dev/null && zoxide query -l 2>/dev/null
        for d in "$HOME"/workspace/*(N/); do print -r -- "$d"; done
      } | awk '!seen[$0]++' | fzf --ansi --no-sort \
        --border-label=' projects & sessions ' --prompt='⚡  ' \
        --preview='
          item={};
          if [[ "$item" == \[tmux\]\ * ]]; then
            s="${item#\[tmux\] }";
            tmux capture-pane -ep -t "$s" 2>/dev/null;
          else
            git -C "$item" log --oneline --color=always -15 2>/dev/null || eza -la --color=always --icons=always "$item" 2>/dev/null || ls -la "$item";
          fi
        ' \
        --preview-window='right,55%,border-left'
    ) || return 0
  fi

  [[ -n "$target" ]] || return 0

  if [[ "$target" == \[tmux\]\ * ]]; then
    session_name="${target#\[tmux\] }"
  else
    [[ -d "$target" ]] || {
      if command -v zoxide &>/dev/null; then
        target=$(zoxide query -- "$target" 2>/dev/null) || return 1
      else
        print -u2 "ts: directory not found: $target"
        return 1
      fi
    }
    session_name="${${target:t}//[.:]/_}"
    if ! tmux has-session -t="=$session_name" 2>/dev/null; then
      tmux new-session -ds "$session_name" -c "$target"
    fi
  fi

  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "=$session_name"
  else
    tmux attach-session -t "=$session_name"
  fi
}

# Yazi file manager wrapper: cd into the directory you quit from (`q`, or `Q` to stay put).
function y() {
  if ! command -v yazi &>/dev/null; then
    print -u2 "y: yazi is not installed"
    return 1
  fi
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Syntax-highlighted `<cmd> --help` pager via bat.
function help() {
  if (( ! $# )); then
    print -u2 "usage: help <command> [args...]"
    return 1
  fi
  "$@" --help 2>&1 | bat --plain --language=help
}

# Lazy-load SDKMAN on first `sdk` call (candidate `current/bin` dirs are on PATH in .zshenv).
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  function sdk() {
    unfunction sdk
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk "$@"
  }
fi

# ------------------------------------------------------------------------------
# 10. Local Overrides & Powerlevel10k Config
# ------------------------------------------------------------------------------
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi

# ------------------------------------------------------------------------------
# 11. Syntax Highlighting (MUST be sourced strictly LAST to wrap all widgets)
# ------------------------------------------------------------------------------
if [[ -o zle && -f "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
  source "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  if [[ -f "$HOME/.zsh/themes/catppuccin-mocha.ini" && ! -f "$ZSH_CACHE_DIR/fsh-catppuccin-applied" ]]; then
    fast-theme "$HOME/.zsh/themes/catppuccin-mocha.ini" >/dev/null 2>&1 && touch "$ZSH_CACHE_DIR/fsh-catppuccin-applied"
  fi
fi

true
