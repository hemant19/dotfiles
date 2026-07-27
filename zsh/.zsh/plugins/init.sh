#!/bin/zsh
## Load Plugins

source $HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -x "$(command -v fzf)" ]] && source <(fzf --zsh)
[[ -x "$(command -v zoxide)" ]] && eval "$(zoxide init zsh)"

# zsh-syntax-highlighting must be sourced LAST: it wraps the ZLE widgets that
# exist at the time it loads, so anything bound after it goes unhighlighted.
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
