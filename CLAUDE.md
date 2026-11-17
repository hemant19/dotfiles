# CLAUDE.md

Personal dotfiles for Hemant Bhoyar across **macOS (Apple Silicon)** and **`agni` (Ubuntu 24.04 LTS ARM64)**, managed with GNU Stow.

## Layout

Each top-level package mirrors `$HOME` via `.stowrc` (`--target=$HOME`):

- **Shared (`macOS` + `agni`):** `zsh/`, `bat/`, `ripgrep/`, `atuin/`, `yazi/`, `mise/`, `tmux/`, `git/`
- **macOS-only:** `ghostty/`, `aerospace/`, `herdr/`, `nvim/`
- **Global Agent Memory:** `agent-memory.md` (symlinked by `install.sh` / `just sync-agent-memory` to `~/.gemini/GEMINI.md`, `~/.gemini/config/GEMINI.md`, `~/.claude/CLAUDE.md`, and `~/.codex/AGENTS.md`)

## Common Commands

```sh
just                   # list all recipes
just install           # full OS-aware bootstrap
just check             # dry-run stow for current OS
just link              # (re)link all packages for current OS
just lint              # zsh -n syntax check on every shell file
just sync-tools        # brew bundle install (macOS) or mise install (Linux)
just sync-agent-memory # link agent-memory.md into ~/.gemini, ~/.claude, ~/.codex
just brew-drift        # non-destructive preview of undeclared Homebrew packages
```

## Conventions & Design Decisions

- **Never edit files under `~` directly** and **never use `stow --adopt`**.
- **Theme & Font:** **Catppuccin Mocha** + **MesloLGS NF** everywhere (`bat`, `ripgrep`, `vivid` `LS_COLORS`, `fzf`, `fzf-tab`, `fast-syntax-highlighting`, `atuin`, `yazi`, `git-delta`, `tmux`, `ghostty`), with **Powerlevel10k** (`~/.p10k.zsh`) for the Zsh prompt.
- **AI-Friendly & Cross-OS GNU Parity (`zsh/.zshenv`):**
  - `.zshenv` runs on *every* Zsh invocation (including non-interactive `zsh -c` from Claude Code, Antigravity, and Codex).
  - On macOS, `.zshenv` prepends Homebrew `gnubin` directories (`gnu-sed`, `coreutils`, `grep`, `findutils`, `gawk`) so GNU flags like `sed -i 's/a/b/'`, `grep -P`, `timeout`, `realpath`, and `stat -c` behave identically on macOS and Linux (`agni`).
  - Non-interactive / non-TTY shells automatically set `PAGER=cat`, `GIT_PAGER=cat`, and `BAT_PAGER=""` so agents never hang on pagers.
  - Global `ripgrep/config` and `bat/config` keep `--color=auto` and omit `--hyperlink-format` so piped/captured output stays clean plain text; interactive human shortcuts (`cat='bat --paging=never'`, `rgh`, `eza --color=auto --icons=auto`) live in interactive-only `zsh/.zshrc`.
- **Prompt (`powerlevel10k`):** Uses the `zsh/.zsh/plugins/powerlevel10k` submodule + `zsh/.p10k.zsh` with instant prompt enabled in `zsh/.zshrc`. Displays `user@host` over SSH while staying minimal locally.
- **Project Switcher (`ts` & tmux `prefix + f`):** Uses a native `tmux` + `zoxide` + `fzf` function in `zsh/.zshrc` (no `sesh` dependency).
- **Linux ARM64 Binary Management (`mise/`):** On `agni` (`aarch64` Ubuntu 24.04), `apt` provides `zsh`, `stow`, `tmux`, and `git`, while `mise` (`mise/.config/mise/config.toml`) installs precompiled ARM64 releases of `fzf`, `eza`, `bat`, `fd`, `ripgrep`, `zoxide`, `delta`, `jq`, `yq`, `sd`, `ast-grep`, `difftastic`, `vivid`, `yazi`, `atuin`, `lazygit`, `just`, `gh`, `tokei`, `hyperfine`, `shellcheck`, and `shfmt`.
- **Agent Supervision in tmux:** `claude agents` (`prefix + a`) owns background agents; tmux only surfaces bells for attached panes (`monitor-bell on` + `prefix + b`). Remember to escape per-session formats as `##{...}` and shell vars as `\$var` inside double-quoted `run-shell` commands.
- **Ghostty <-> `agni` Terminfo:** Ghostty enables `shell-integration-features = ssh-terminfo,ssh-env`, and `xterm-ghostty` terminfo is compiled into `~/.terminfo` on `agni` so `tailscale ssh` / `rex` sessions also get full truecolor and keybindings. Never `export TERM` in Zsh files.
