#!/bin/zsh
set -e

cd "$(dirname "$0")"

#### Fetch zsh plugins and tpm (tracked as git submodules)
echo "==> Syncing submodules"
git submodule update --init --recursive

#### Install all apps from Brew
echo "==> Installing Homebrew packages"
brew bundle install

#### Install sdkman
if [[ ! -d "$HOME/.sdkman" ]]; then
  echo "==> Installing sdkman"
  curl -s "https://get.sdkman.io" | bash
else
  echo "==> sdkman already installed, skipping"
fi

#### Install and init config
mac_config=(nvim zsh tmux wezterm ghostty aerospace git)

for config in $mac_config; do
  echo "==> Stowing $config"
  if [[ -f "$config-install.sh" && -x "$config-install.sh" ]]; then
    echo "    Found $config-install.sh. Executing..."
    ./$config-install.sh
  fi
  # Deliberately no --adopt: that pulls whatever is in $HOME *into* this repo,
  # silently overwriting committed config. If stow reports a conflict, inspect
  # the offending file and remove it by hand, then re-run.
  stow -R -v "$config"
done

echo "==> Done. Restart your shell (and tmux server) to pick everything up."
