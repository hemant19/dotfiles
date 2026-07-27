# dotfiles

Personal macOS setup for Hemant Bhoyar (hybhoyar@gmail.com), managed with
[GNU Stow](https://www.gnu.org/software/stow/).

Neovim (LazyVim) · zsh (powerlevel10k) · tmux · Ghostty · WezTerm · AeroSpace —
themed with Catppuccin Mocha throughout, MesloLGS NF everywhere.

## Install

```sh
git clone --recurse-submodules git@github.com:hemant19/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles
./install.sh
```

`install.sh` syncs submodules, installs everything in the `Brewfile`, installs
sdkman, then stows every package. Re-running it is safe.

If you already have `just` installed, `just --list` shows the shortcuts.

## Layout

Every top-level directory is a stow package whose contents mirror `$HOME`:

| Package     | Links to |
|-------------|----------|
| `zsh/`      | `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh`, `~/.zsh/` |
| `nvim/`     | `~/.config/nvim/` |
| `tmux/`     | `~/.tmux.conf`, `~/.tmux/` |
| `git/`      | `~/.gitconfig`, `~/.config/git/` |
| `ghostty/`  | `~/.config/ghostty/` |
| `wezterm/`  | `~/.wezterm.lua` |
| `aerospace/`| `~/.config/aerospace/` |

```sh
stow -R <pkg>     # (re)link one package
stow -D <pkg>     # unlink one package
stow -n -v <pkg>  # dry run -- do this before restowing
```

`.stowrc` pins `--target=$HOME`, so plain `stow <pkg>` from the repo root works.

## Machine-specific config

Anything host-specific (work paths, credentials, per-machine `PATH` entries)
goes in `~/.zshrc.local`, which `.zshrc` sources at the end and which is
deliberately **not** tracked here.

## Notes

- zsh plugins and tpm are git submodules under `zsh/.zsh/plugins/` and
  `tmux/.tmux/plugins/`; there is no plugin manager for zsh.
- tmux prefix is `C-z`. `prefix + f` opens the project switcher; `prefix + I`
  installs new tpm plugins.
- `nvim/.config/nvim/lazy-lock.json` is intentionally untracked.
