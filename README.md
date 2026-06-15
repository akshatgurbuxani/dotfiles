# dotfiles

Personal environment configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's inside

| Directory | Manages |
|-----------|---------|
| `nvim/` | Editor config, plugins, LSP, keymaps |
| `zsh/` | Shell aliases, prompt (powerlevel10k), fzf, zoxide |
| `tmux/` | Terminal multiplexer config, TPM plugins |
| `git/` | Global git config, credential helper |
| `ghostty/` | Ghostty terminal config (used by cmux) |
| `Brewfile` | Homebrew packages (formulae + casks) |

## Setup

**Prerequisite:** [Homebrew](https://brew.sh)

```bash
# Clone anywhere — setup.sh detects its own location
git clone https://github.com/akshatgurbuxani/dotfiles
cd dotfiles
./setup.sh
```

Then:
- **Tmux:** press `prefix + I` to install TPM plugins
- **Neovim:** plugins install automatically on first launch
- **Restart your terminal**

## Updating another machine

```bash
cd dotfiles
git pull
```

Symlinks already point to the repo — changes take effect immediately.

## Machine-specific overrides

These files are gitignored. Create them for per-machine config:

| File | Purpose |
|------|---------|
| `~/.zshrc.local` | Shell overrides (PATHs, work proxies) |
| `~/.gitconfig.local` | Work git user, different email |
| `~/.config/nvim/init.local.lua` | Neovim overrides (formatters, work settings) |

See `*.example` files in the repo for templates.

## Managing packages

```bash
# Add a new config
mkdir -p dotfiles/newpkg/.config/app
stow newpkg

# Remove a config
stow -D newpkg

# Move the repo elsewhere
mv dotfiles /new/path
cd /new/path
./setup.sh    # re-creates symlinks
```
