# Login shell environment.
# Core PATH (including Homebrew, mise shims, ~/.local/bin, and macOS GNU userland)
# is already configured in ~/.zshenv so non-login shells and AI agents share it.

typeset -U path PATH

if [[ "$OSTYPE" == darwin* && -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
fi

# Machine-specific login overrides live in ~/.zprofile.local (untracked).
if [[ -f "$HOME/.zprofile.local" ]]; then
  source "$HOME/.zprofile.local"
fi
