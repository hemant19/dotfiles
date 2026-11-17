# Sourced by EVERY zsh invocation (interactive, login, scripts, and AI agent `zsh -c`).
# Keep this file fast and completely silent (zero stdout/stderr).

typeset -U path PATH

# 1. macOS Homebrew base PATH
if [[ "$OSTYPE" == darwin* && -d /opt/homebrew ]]; then
  path=("/opt/homebrew/bin" "/opt/homebrew/sbin" $path)
fi

# 2. User-level shims & binaries (higher precedence than /opt/homebrew/bin)
for _dir in \
  "$HOME/.docker/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.local/bin" \
  "$HOME/.local/share/mise/shims"
do
  [[ -d "$_dir" ]] && path=("$_dir" $path)
done

# Cached direct PATH from mise (avoids ~35ms per-call shim overhead on Linux)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-env.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-env.zsh"
fi

# Zero-cost SDKMAN candidate binaries on PATH (avoids 200ms sdkman-init.sh in non-interactive shells)
for _sdk_bin in "$HOME"/.sdkman/candidates/*/current/bin(N-/); do
  path=("$_sdk_bin" $path)
done

# 3. macOS GNU userland parity with Linux (sed, awk, grep, find, xargs, coreutils)
if [[ "$OSTYPE" == darwin* && -d /opt/homebrew ]]; then
  for _gnubin in \
    /opt/homebrew/opt/gnu-sed/libexec/gnubin \
    /opt/homebrew/opt/coreutils/libexec/gnubin \
    /opt/homebrew/opt/grep/libexec/gnubin \
    /opt/homebrew/opt/findutils/libexec/gnubin \
    /opt/homebrew/opt/gawk/libexec/gnubin
  do
    [[ -d "$_gnubin" ]] && path=("$_gnubin" $path)
  done
fi
unset _dir _sdk_bin _gnubin
export PATH

# 4. Tool defaults (TTY-safe: colors only render on interactive terminals)
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
export BAT_THEME="Catppuccin Mocha"

# 5. Non-interactive / non-TTY guard (AI coding agents, CI, pipes): never block on pagers
if [[ ! -o interactive || ! -t 1 ]]; then
  export PAGER=cat
  export GIT_PAGER=cat
  export BAT_PAGER=""
  export MANPAGER=cat
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

if [[ -f "$HOME/.zshenv.local" ]]; then
  source "$HOME/.zshenv.local"
fi
