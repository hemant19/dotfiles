# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export EDITOR=nvim

# Rebuild the completion dump (and run the slow security check) at most once a
# day; use the cached dump on every other shell start.
autoload -Uz compinit
# Glob qualifiers: N = no error when missing, . = regular file,
# mh-24 = modified within the last 24 hours. Globbing only happens in an
# assignment like this -- inside [[ ]] the pattern would stay literal.
_zcompdump_fresh=($HOME/.zcompdump(N.mh-24))
if (( $#_zcompdump_fresh )); then
  compinit -C   # dump is recent: skip the security scan
else
  compinit      # rebuild the dump and run the full check
fi
unset _zcompdump_fresh

source $HOME/.zsh/plugins/init.sh
source $HOME/.zsh/aliases.sh
source $HOME/.zsh/options.sh
source $HOME/.zsh/functions.sh

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
[[ -s "$HOME/.docker/bin/docker" ]] && export PATH="$HOME/.docker/bin":$PATH

[[ ! -f $HOME/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Machine-specific config (paths, credentials, per-host tweaks) lives here and
# is deliberately not tracked in this repo.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
