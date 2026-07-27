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
| `ghostty/`  | `~/.config/ghostty/config`  | Ghostty terminal |
| `wezterm/`  | `~/.wezterm.lua`            | WezTerm terminal |
| `aerospace/`| `~/.config/aerospace/`      | AeroSpace tiling WM |

`.stowrc` pins `--target=$HOME`, so `stow <pkg>` from the repo root is enough.

## Common commands

```sh
./install.sh                 # brew bundle + sdkman + stow every package
stow <pkg>                   # link one package
stow -D <pkg>                # unlink one package
stow -n -v <pkg>             # dry run — always do this before restowing
brew bundle install          # install everything in Brewfile
brew bundle dump --force     # regenerate Brewfile from current machine
git submodule update --init --recursive   # fetch zsh plugins + tpm
```

## Conventions

- **Never edit files under `~` directly** — they're symlinks into this repo,
  except where stow failed to link (see Gotchas). Edit here, changes are live.
- Shell config is split by concern under `zsh/.zsh/`: `aliases.sh`,
  `options.sh`, `functions.sh`, `plugins/init.sh`. `.zshrc` only sources them.
  Add new shell code to the right file, not to `.zshrc`.
- `.zprofile` = login-shell env (PATH, brew shellenv). `.zshrc` = interactive
  shell (prompt, plugins, aliases).
- Theme across the whole setup is **Catppuccin Mocha**; font is
  **MesloLGS NF**. Keep new configs consistent with both.
- zsh plugins are git submodules under `zsh/.zsh/plugins/`, loaded explicitly
  by `plugins/init.sh` — no plugin manager. Adding a plugin means
  `git submodule add` + a `source` line there.
- Neovim is LazyVim; custom plugin specs go in
  `nvim/.config/nvim/lua/plugins/*.lua`, one file per concern. LazyVim extras
  are toggled in `lazyvim.json`.
- tmux prefix is `C-z` (not `C-b`). tmux plugins are TPM-managed; new plugins
  need `prefix + I` to install.

## Gotchas

- `nvim/.config/nvim/lazy-lock.json` is listed in `.gitignore` but is still
  **tracked**, so it keeps showing up as modified. Needs `git rm --cached` to
  actually take effect.
- `~/.config/ghostty/config` is a **real file, not a symlink** — the repo's
  ghostty package is not currently stowed and the two have drifted.
- `install.sh`'s package list omits `tmux` and `wezterm`; it also uses
  `stow --adopt`, which overwrites repo content with whatever is in `$HOME`.
  Verify `git diff` after running it.
- `zsh/.zsh/scripts/tmux-sessionizer.sh` is referenced by **absolute path** in
  `tmux.conf` (`bind f`), so the repo must live at
  `~/workspace/dotfiles`.
- `.zshrc` contains machine-specific paths (gcloud SDK, Antigravity CLI) that
  installers appended; they are not portable to another machine.
