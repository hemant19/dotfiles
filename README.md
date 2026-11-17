# dotfiles

Personal setup for Hemant Bhoyar (`hybhoyar@gmail.com`) across **macOS** and **Linux (`agni` ARM64)**, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Powerlevel10k · Zsh (`fzf-tab`, `fast-syntax-highlighting`, Atuin, Yazi, Zoxide) · Ripgrep / Bat / Eza / Vivid / JQ / YQ · tmux · Ghostty · Herdr · AeroSpace — themed in **Catppuccin Mocha** with **MesloLGS NF** throughout.

## Install

```sh
git clone --recurse-submodules git@github.com:hemant19/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles
./install.sh
```

`install.sh` detects the OS automatically:
- **macOS:** syncs submodules, installs `Brewfile` packages (including GNU userland tools), stows all packages, builds the `bat` theme cache, and links global AI agent memory.
- **Linux (`agni`):** syncs submodules, installs `zsh`/`stow`/`tmux`/`git` via `apt`, stows shared CLI packages, installs precompiled ARM64 CLI tools via `mise`, builds the `bat` cache, and links global AI agent memory.

Run `just --list` for everyday tasks (`just check`, `just link`, `just lint`, `just sync-tools`).

## Highlights

- **Cross-Host Prompt (`powerlevel10k`):** Lean 1-line prompt with instant prompt (`~/.p10k.zsh`), displaying `user@host` automatically over SSH.
- **Interactive Shell Ergonomics:**
  - `<Tab>` — `fzf-tab` completion popups with live `eza` tree & `bat` file previews
  - `Ctrl-R` — Atuin local SQLite history (with exit codes, duration, and directory filtering)
  - `Ctrl-T` / `Alt-C` — `fd`-backed `fzf` file & directory pickers
  - `y` — Yazi terminal file manager (`cd`s to chosen directory on quit)
  - `cd` / `cdi` (and `z` / `zi`) — zoxide-backed smart directory jumping
  - `cat` — `bat --paging=never` with Catppuccin Mocha syntax highlighting (raw output when piped)
  - `ts` / tmux `C-z f` — project & tmux session switcher (`tmux` + `zoxide` + `fzf`)
- **AI-Ready CLI Parity:** `~/.zshenv` exposes `rg`, `fd`, `jq`, `yq`, `ast-grep` (`sg`), `sd`, `difft`, `gh`, and GNU `sed`/`awk`/`grep`/`find`/`coreutils` uniformly on both macOS and Linux, while keeping piped/non-TTY output clean and unpaged.
- **Machine-Specific Config:** Place host-only tweaks or secrets in `~/.zshrc.local` or `~/.zshenv.local` (untracked).
