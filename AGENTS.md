# AGENTS.md

Cross-platform dotfiles repository for **macOS (Apple Silicon)** and **`agni` (Ubuntu 24.04 LTS ARM64)**, managed with **GNU Stow** (`.stowrc` sets `--target=$HOME`).

- **Theme:** Catppuccin Mocha (Ghostty, tmux, bat, ripgrep, fzf, fzf-tab, fast-syntax-highlighting, vivid, git-delta, Atuin, Yazi, Neovim) + Powerlevel10k prompt (`~/.p10k.zsh`)
- **Font:** MesloLGS NF (`font-meslo-lg-nerd-font`)

## Repository Structure

### Root Files

| File | Purpose |
|------|---------|
| `.stowrc` | Pins `--target=$HOME` so `stow <pkg>` works from repo root |
| `Brewfile` | Curated macOS Homebrew taps, formulae, GNU userland, fonts, and casks |
| `install.sh` | OS-aware bootstrap (`Darwin` via Homebrew; `Linux` via `apt` + `mise` + Stow + agent memory) |
| `justfile` | Task runner shortcuts (`install`, `link`, `unlink`, `check`, `lint`, `sync-tools`, `sync-agent-memory`) |
| `agent-memory.md` | Source of truth symlinked to `~/.gemini/GEMINI.md`, `~/.claude/CLAUDE.md`, and `~/.codex/AGENTS.md` |
| `.gitmodules` | Git submodules: `fzf-tab`, `zsh-autosuggestions`, `fast-syntax-highlighting`, `powerlevel10k`, and tmux `tpm` |
| `CLAUDE.md` | Architecture notes and historical gotchas |

### Stow Packages

| Package | Scope | Symlink Target(s) in `$HOME` | Notes |
|---------|-------|------------------------------|-------|
| `zsh` | Shared | `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.p10k.zsh`, `~/.zsh/` | Zsh + Powerlevel10k + GNU `PATH` parity + `fzf-tab` + `fast-syntax-highlighting` |
| `bat` | Shared | `~/.config/bat/` | `config` + bundled `Catppuccin Mocha.tmTheme` (`--color=auto --paging=auto`) |
| `ripgrep` | Shared | `~/.config/ripgrep/config` | TTY-only Catppuccin Mocha RGB colors + `--smart-case` |
| `atuin` | Shared | `~/.config/atuin/` | Local/offline SQLite `Ctrl-R` shell history (`auto_sync = false`) |
| `yazi` | Shared | `~/.config/yazi/` | Terminal file manager (`y` shell wrapper `cd`s on exit) |
| `mise` | Shared | `~/.config/mise/config.toml` | Precompiled ARM64 CLI binary manifest for Linux (`agni`) |
| `tmux` | Shared | `~/.tmux.conf`, `~/.tmux/` | Prefix `C-z`; `prefix + f` runs `ts`; TPM submodule in `.tmux/plugins/tpm` |
| `git` | Shared | `~/.gitconfig`, `~/.config/git/ignore` | `delta` default pager + `git dft` (`difftastic`) + global gitignore |
| `ghostty` | macOS | `~/.config/ghostty/config` | Primary terminal (`ssh-terminfo,ssh-env` integration enabled) |
| `herdr` | macOS | `~/.config/herdr/config.toml`, `~/.config/herdr-app/{settings,keys}.json` | Herdr CLI & app configs (parent dirs pre-created so logs/runtime state stay untracked) |
| `aerospace` | macOS | `~/.config/aerospace/aerospace.toml` | AeroSpace tiling window manager (`config-version = 2`) |
| `nvim` | macOS | `~/.config/nvim/` | LazyVim starter (`lazy-lock.json` gitignored) |

## Where to Put Changes

- **Shell (`zsh/`):**
  - `zsh/.zshenv` — universal `PATH` (including macOS Homebrew `gnubin` for GNU `sed`/`awk`/`grep`/`find`/`coreutils` parity with Linux, `mise` shims, `~/.local/bin`), `RIPGREP_CONFIG_PATH`, and non-TTY pager disabling for AI agents. Must emit **zero output**.
  - `zsh/.zprofile` — login-shell env (`HOMEBREW_*`, `~/.zprofile.local`).
  - `zsh/.zshrc` — single-file interactive config: Powerlevel10k instant prompt, options & 100k history, `compinit`, cached `vivid` `LS_COLORS`, `FZF_*` defaults, plugins (`powerlevel10k`, `fzf-tab`, `zsh-autosuggestions`, `fzf`, `atuin`, `zoxide --cmd cd`), interactive aliases (`eza`, `cat` -> `bat --paging=never`, `z`/`zi`, `rgh`, `dft`), functions (`tm`, `ts`, `y`, `help`, lazy `sdk`), `~/.zshrc.local`, `~/.p10k.zsh`, and `fast-syntax-highlighting` strictly last. Always exit functions with `return`, never `exit`.
  - `~/.zshrc.local` / `~/.zshenv.local` *(untracked in `$HOME`)* — host-specific paths, credentials, work SDKs.

## Verification Commands

```sh
just check               # Dry-run stow for current OS packages
just lint                # Syntax-check all zsh scripts
just link                # Apply stow symlinks (never pass --adopt)
just sync-agent-memory   # Refresh ~/.gemini/GEMINI.md, ~/.claude/CLAUDE.md, ~/.codex/AGENTS.md
```

## Key Guardrails

1. **Edit in-repo, never via `~`**, and **never run `stow --adopt`**.
2. **Keep CLI configs AI-safe:** never put `--color=always` or `--hyperlink-format` into `ripgrep/config` or `bat/config`, and never shadow `sed`/`grep`/`find` with incompatible aliases (`cat='bat --paging=never'` lives in interactive-only `zsh/.zshrc` and outputs raw text when piped).
3. **Use `$HOME` or `~`**, never hardcoded `/Users/...` or `/home/...` paths.
4. **Do not `export TERM`** in zsh config — Ghostty, WezTerm, and tmux set `TERM` properly; on remote Linux hosts install `xterm-ghostty` terminfo instead.
5. **Keep `fast-syntax-highlighting` sourced strictly last** at the end of `zsh/.zshrc`.
