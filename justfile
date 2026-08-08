packages := "nvim zsh tmux wezterm ghostty aerospace git sesh"

# List available recipes
default:
    @just --list

# Full bootstrap: submodules, brew packages, and all symlinks
install:
    ./install.sh

# Symlink every package into $HOME
link:
    stow -R -v {{packages}}

# Remove every symlink from $HOME
unlink:
    stow -D -v {{packages}}

# Show what `just link` would do, without touching anything
check:
    stow -n -R -v {{packages}}

# Symlink a single package, e.g. `just link-one nvim`
link-one pkg:
    stow -R -v {{pkg}}

# Pull the latest zsh plugins and tpm
update-submodules:
    git submodule update --init --recursive --remote

# Sync Homebrew with the Brewfile
brew-sync:
    brew bundle install

# Report anything installed by brew that the Brewfile does not declare
brew-drift:
    brew bundle cleanup

# Syntax-check the shell files
lint:
    #!/usr/bin/env zsh
    set -e
    for f in zsh/.zshrc zsh/.zprofile zsh/.zsh/*.sh zsh/.zsh/plugins/init.sh zsh/.zsh/scripts/*.sh(N) install.sh; do
        zsh -n "$f" && echo "ok  $f"
    done
