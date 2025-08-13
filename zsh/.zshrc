# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export EDITOR=nvim

autoload -U compinit; compinit

if [[ $(uname) == "Darwin" ]]; then
  source $HOME/.zsh/macos.sh
fi

source $HOME/.zsh/plugins/init.sh
source $HOME/.zsh/aliases.sh
source $HOME/.zsh/options.sh
source $HOME/.zsh/functions.sh

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ ! -f $HOME/.p10k.zsh ]] || source ~/.p10k.zsh

