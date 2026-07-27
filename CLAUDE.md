# CLAUDE.md

Personal macOS dotfiles for Hemant Bhoyar, managed with GNU Stow.

## Layout

Each top-level directory is a **stow package**. Its internal structure mirrors
`$HOME`, so `zsh/.zshrc` is symlinked to `~/.zshrc` and
`nvim/.config/nvim/` to `~/.config/nvim/`.

| Package     | Links to                    | Contents |
|-------------|-----------------------------|----------|
| `zsh/`      | `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh`, `~/.zsh/` | shell config, plugins (submodules), aliases, functions, scripts |
| `nvim/`     | `~/.config/nvim/`           | LazyVim-based Neovim config |
| `tmux/`     | `~/.tmux.conf`, `~/.tmux/`  | tmux config + TPM (submodule) |
| `git/`      | `~/.gitconfig`, `~/.config/git/` | git config + global gitignore |
| `ghostty/`  | `~/.config/ghostty/`        | Ghostty terminal |
| `wezterm/`  | `~/.wezterm.lua`            | WezTerm terminal |
| `aerospace/`| `~/.config/aerospace/`      | AeroSpace tiling WM |

`.stowrc` pins `--target=$HOME`, so `stow <pkg>` from the repo root is enough.

## Common commands

```sh
just              # list all recipes
just install      # full bootstrap (submodules + brew + stow)
just link         # (re)link every package
just check        # dry-run the linking
just lint         # zsh -n every shell file
just brew-drift   # what's installed but not in the Brewfile

stow -R <pkg>     # (re)link one package
stow -D <pkg>     # unlink one package
stow -n -v <pkg>  # dry run -- always do this before restowing
```

## Conventions

- **Never edit files under `~` directly** — they're symlinks into this repo.
  Edit here; changes are live immediately.
- Shell config is split by concern under `zsh/.zsh/`: `aliases.sh`,
  `options.sh`, `functions.sh`, `plugins/init.sh`. `.zshrc` only sources them.
  Add new shell code to the right file, not to `.zshrc`.
- `.zprofile` = login-shell env (PATH, brew shellenv). `.zshrc` = interactive
  shell (prompt, plugins, aliases).
- **Machine-specific config goes in `~/.zshrc.local`**, which `.zshrc` sources
  last and which is not tracked. Never commit host paths or credentials to the
  repo — installers that append to `.zshrc` should be moved out to `.local`.
- Theme across the whole setup is **Catppuccin Mocha**; font is
  **MesloLGS NF**. Keep new configs consistent with both — that includes
  `BAT_THEME`, the fzf colour flags, delta's `syntax-theme`, and the tmux and
  Neovim themes.
- zsh plugins are git submodules under `zsh/.zsh/plugins/`, loaded explicitly
  by `plugins/init.sh` — no plugin manager. Adding one means
  `git submodule add` + a `source` line there.
  **zsh-syntax-highlighting must stay last** in that file.
- Neovim is LazyVim; custom plugin specs go in
  `nvim/.config/nvim/lua/plugins/*.lua`, one file per concern. LazyVim extras
  are toggled in `lazyvim.json`.
- tmux prefix is `C-z` (not `C-b`). tmux plugins are TPM-managed; new plugins
  need `prefix + I` to install.
- Paths inside configs must be `~`-relative, never `/Users/hemant/...`, so the
  repo works from any checkout location.
- The `Brewfile` is curated by hand and should mirror what's actually
  installed. `brew bundle check` should stay clean.

## Gotchas

- `nvim/.config/nvim/lazy-lock.json` is **deliberately untracked and ignored**
  (`.gitignore:5`). Don't re-add it. The file still exists on disk and Neovim
  uses it; it just isn't versioned.
- `install.sh` deliberately does **not** use `stow --adopt` — that pulls files
  from `$HOME` into the repo and silently overwrites committed config. On a
  stow conflict, inspect and remove the offending file in `$HOME` by hand.
- `zsh/.zsh/scripts/tmux-sessionizer.sh` is the single implementation of the
  project switcher; the `ts` shell function and the tmux `prefix + f` binding
  both call it. Don't reintroduce a copy.
- Do not `export TERM` in shell config — the terminal and tmux set it, and
  overriding breaks true colour, italics and undercurl.
- Shell functions must use `return`, never `exit` — `exit` in a sourced
  function kills the user's interactive shell.
- Globbing does not happen inside `[[ ]]`. The compinit cache check in
  `.zshrc` uses an array assignment for exactly this reason.
