# Login shell environment. Interactive-only config belongs in .zshrc.

# Keep PATH free of duplicates no matter how many installers prepend to it.
typeset -U path PATH

# Homebrew (Apple Silicon path; falls back silently on machines without it)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Machine-specific PATH entries live in ~/.zshrc.local, not in this repo.
