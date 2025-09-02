#!/bin/zsh
## Load Plugins

source $HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -x "$(command -v fzf &>/dev/null)"]] source <(fzf --zsh)
[[ -x "$(command -v zoxide &>/dev/null)"]] eval "$(zoxide init zsh)"


