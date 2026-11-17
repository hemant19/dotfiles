# Global Environment & CLI Tooling Memory

This shell and CLI environment is mirrored across **macOS (Apple Silicon)** and **`agni` (Ubuntu 24.04 LTS ARM64)** via `~/workspace/dotfiles` (GNU Stow).

## Pre-Installed Fast CLI Toolkit (Always on `PATH`)

 `~/.zshenv` automatically configures `PATH` for both interactive shells and non-interactive agent commands (`zsh -c`), and disables interactive pagers (`PAGER=cat`, `GIT_PAGER=cat`, `BAT_PAGER=""`) whenever stdout is non-interactive.

Prefer these fast, deterministic tools over slow ad-hoc Python/Node one-liners or legacy POSIX loops:

- **Search & Discovery:**
  - `rg` (`ripgrep`): Fast regex search (`--smart-case` enabled by default; outputs clean `file:line:text` when non-TTY).
  - `fd`: Fast `.gitignore`-aware file/directory finder.
  - `ast-grep` (invoke as `ast-grep` across OSes, since `/usr/bin/sg` on Linux can shadow `sg`): Syntax-aware AST search and structural code rewrites (`ast-grep -p '...' -l ts`).
  - `tokei`: Instant language/line-count codebase overview.
- **Structured Data (`JSON` / `YAML` / `TOML` / `XML` / `CSV`):**
  - `jq`: Query, filter, and transform JSON safely instead of regex-grepping JSON.
  - `yq` (`mikefarah/yq` v4): Query and edit YAML, TOML, XML, CSV, and JSON in place (`yq -i '.foo = "bar"' file.yaml`).
- **Text Replacement & GNU Userland Parity (`macOS` == `Linux`):**
  - **GNU tools are first on `PATH` on macOS too** (`gnu-sed`, `coreutils`, `grep`, `findutils`, `gawk` via Homebrew `gnubin` in `~/.zshenv`).
  - Standard GNU syntax works identically on both Mac and `agni`: `sed -i 's/old/new/g' file` (no BSD `sed -i ''` workaround needed), `grep -P`, `find -printf`, `timeout`, `realpath`, `stat -c`.
  - `sd`: Clean literal (`sd -F 'before' 'after' file`) or Rust-regex in-place replacement without slash-escaping issues.
- **Diffs, Git, Shell Quality & Benchmarking:**
  - `gh`: GitHub CLI for PRs, issues, actions, and API calls.
  - `difft` (`difftastic` / `git dft`): Structural AST diffs when reviewing refactors.
  - `shellcheck` & `shfmt`: Lint and format shell scripts after editing.
  - `hyperfine`: Benchmark commands empirically.
  - `just` & `uv`: Task runner and fast Python package/script runner (`uv run`).

## Dotfiles & Host Guardrails

- Dotfiles live in `~/workspace/dotfiles` (GNU Stow -> `$HOME`); edit tracked configs inside `~/workspace/dotfiles`, never via `~` symlinks directly, and never run `stow --adopt`.
- Machine-specific secrets/paths belong in untracked `~/.zshrc.local` or `~/.zshenv.local`.
- Do not add `--color=always` or `--hyperlink-format` to global tool configs (`ripgrep/config`, `bat/config`), so piped and agent-captured outputs stay free of ANSI/OSC escape sequences.
