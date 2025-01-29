# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export EDITOR=nvim

autoload -U compinit; compinit

## Load Plugins

source $HOME/.zsh/plugins/p10k/powerlevel10k.zsh-theme
source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ ! -f $HOME/.p10k.zsh ]] || source ~/.p10k.zsh
