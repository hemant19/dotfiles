#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
REPO_DIR="$PWD"
OS="$(uname -s)"

echo "==> Syncing git submodules"
git submodule update --init --recursive

if [[ "$OS" == "Darwin" ]]; then
  echo "==> Installing Homebrew packages (macOS)"
  HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install

  if [[ ! -d "$HOME/.sdkman" ]]; then
    echo "==> Installing SDKMAN (rcupdate=false so .zshrc stays untouched)"
    curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash
  else
    echo "==> SDKMAN already installed, skipping"
  fi

  stow_packages=(zsh tmux git bat ripgrep atuin yazi mise nvim ghostty aerospace herdr)
elif [[ "$OS" == "Linux" ]]; then
  echo "==> Installing base OS packages (Linux)"
  if command -v apt-get &>/dev/null; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq zsh stow git tmux curl wget unzip tree gawk findutils sed grep coreutils
  fi

  if [[ ! -x "$HOME/.local/bin/mise" ]] && ! command -v mise &>/dev/null; then
    echo "==> Installing mise"
    curl -fsSL https://mise.run | MISE_QUIET=1 sh
  fi

  stow_packages=(zsh tmux git bat ripgrep atuin yazi mise)
else
  echo "Unsupported OS: $OS" >&2
  exit 1
fi

# Pre-create shared/runtime parent dirs so Stow links individual files instead of tree-folding.
mkdir -p "$HOME/.config" "$HOME/.config/herdr" "$HOME/.config/herdr-app" "$HOME/.config/herdr-app/themes" "$HOME/.cache/zsh"

for pkg in "${stow_packages[@]}"; do
  echo "==> Stowing $pkg"
  # Deliberately no --adopt: inspect & back up any conflicting regular files in $HOME manually.
  stow -R -v "$pkg"
done

if [[ "$OS" == "Linux" ]]; then
  MISE_BIN="$(command -v mise 2>/dev/null || echo "$HOME/.local/bin/mise")"
  echo "==> Installing portable CLI tools via mise"
  "$MISE_BIN" install --yes
  "$MISE_BIN" env -s zsh >| "$HOME/.cache/zsh/mise-env.zsh"
fi

# Rebuild bat syntax/theme cache so Catppuccin Mocha is registered
BAT_BIN="$(command -v bat 2>/dev/null || echo "$HOME/.local/share/mise/shims/bat")"
if [[ -x "$BAT_BIN" ]]; then
  echo "==> Rebuilding bat theme cache"
  "$BAT_BIN" cache --build >/dev/null
fi

# Link global AI agent memory (Antigravity / Gemini CLI, Claude Code, Codex)
# Always mkdir target parent dirs first so runtime agent state directories are never tree-folded.
echo "==> Linking global AI agent memory"
mkdir -p "$HOME/.gemini/config" "$HOME/.claude" "$HOME/.codex"
ln -sfn "$REPO_DIR/agent-memory.md" "$HOME/.gemini/GEMINI.md"
ln -sfn "$REPO_DIR/agent-memory.md" "$HOME/.gemini/config/GEMINI.md"
ln -sfn "$REPO_DIR/agent-memory.md" "$HOME/.claude/CLAUDE.md"
ln -sfn "$REPO_DIR/agent-memory.md" "$HOME/.codex/AGENTS.md"

echo "==> Done! Open a new zsh session (and run 'prefix + I' in tmux if needed)."
