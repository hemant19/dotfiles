shared_packages := "zsh tmux git bat ripgrep atuin yazi mise"
macos_packages := "nvim ghostty aerospace herdr"
packages := if os() == "macos" { shared_packages + " " + macos_packages } else { shared_packages }

# List available recipes
default:
    @just --list

# Full bootstrap for current OS (macOS Homebrew or Linux apt + mise, stow, agent memory)
install:
    ./install.sh

# Symlink all packages for the current OS into $HOME
link:
    mkdir -p "$HOME/.config" "$HOME/.config/herdr" "$HOME/.config/herdr-app" "$HOME/.config/herdr-app/themes"
    stow -R -v {{packages}}

# Remove symlinks for the current OS from $HOME
unlink:
    stow -D -v {{packages}}

# Dry-run stow without modifying $HOME
check:
    mkdir -p "$HOME/.config" "$HOME/.config/herdr" "$HOME/.config/herdr-app" "$HOME/.config/herdr-app/themes"
    stow -n -R -v {{packages}}

# Symlink a single package, e.g. `just link-one zsh`
link-one pkg:
    stow -R -v {{pkg}}

# Symlink global AI agent memory into ~/.gemini, ~/.claude, and ~/.codex
sync-agent-memory:
    mkdir -p "$HOME/.gemini/config" "$HOME/.claude" "$HOME/.codex"
    ln -sfn "$PWD/agent-memory.md" "$HOME/.gemini/GEMINI.md"
    ln -sfn "$PWD/agent-memory.md" "$HOME/.gemini/config/GEMINI.md"
    ln -sfn "$PWD/agent-memory.md" "$HOME/.claude/CLAUDE.md"
    ln -sfn "$PWD/agent-memory.md" "$HOME/.codex/AGENTS.md"

# Pull latest git submodules (zsh plugins + tmux tpm)
update-submodules:
    git submodule update --init --recursive --remote

# Sync Homebrew with Brewfile (macOS) or mise tools (Linux)
sync-tools:
    #!/usr/bin/env zsh
    set -euo pipefail
    if [[ "$(uname -s)" == "Darwin" ]]; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install
    else
        mise install --yes
        mkdir -p "$HOME/.cache/zsh"
        mise env -s zsh >| "$HOME/.cache/zsh/mise-env.zsh"
    fi

# Safely preview Homebrew formulae/casks not listed in Brewfile without uninstalling
brew-drift:
    echo n | brew bundle cleanup || true

# Syntax-check all shell scripts
lint:
    #!/usr/bin/env zsh
    set -e
    for f in zsh/.zshenv zsh/.zprofile zsh/.zshrc; do
        zsh -n "$f" && echo "ok  $f"
    done
    bash -n install.sh && echo "ok  install.sh"
    if command -v shellcheck &>/dev/null; then
        shellcheck install.sh && echo "ok  shellcheck install.sh"
    fi
