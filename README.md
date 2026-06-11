# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| Package | What it tracks |
|---------|---------------|
| `nvim/` | Neovim config (`init.lua`), plugins, keymaps, LSP |
| `zsh/` | Shell aliases, prompt (powerlevel10k), fzf, zoxide, completions |
| `tmux/` | Tmux config, keybinds, TPM plugins |
| `git/` | Git config, credential helper, aliases |
| `Brewfile` | All Homebrew packages (formulae, casks, VS Code extensions, npm) |

## Setup on a new machine

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone
git clone https://github.com/YOUR_USER/dotfiles ~/dotfiles

# 3. Run setup
cd ~/dotfiles && chmod +x setup.sh && ./setup.sh

# 4. Tmux: prefix + I  (capital I) to install TPM plugins
# 5. Neovim: plugins auto-install on first open via lazy.nvim
# 6. Restart your terminal
```

## Machine-specific overrides (NOT in git)

Create any of these for per-machine config:

- `~/.zshrc.local` — shell overrides (e.g., work proxies, machine-specific PATHs)
- `~/.gitconfig.local` — git user for work machine
- `~/.config/nvim/init.local.lua` — neovim overrides (e.g., different formatters)

Example templates are in the repo at `git/.gitconfig.local.example` and
`nvim/.config/nvim/init.local.example.lua`.

## Daily use

Edit files in `~/dotfiles/` — changes are instantly reflected (symlinks).

To add a new package:
1. Create a directory: `mkdir -p ~/dotfiles/newpkg/.config/newapp`
2. Place your config: `cp ~/.config/newapp/config ~/dotfiles/newpkg/.config/newapp/`
3. Stow it: `cd ~/dotfiles && stow newpkg`

To remove a package: `cd ~/dotfiles && stow -D pkgname`

## Keeping in sync

```bash
# Personal machine: push changes
cd ~/dotfiles && git add -A && git commit -m "..." && git push

# Work machine: pull updates
cd ~/dotfiles && git pull && stow --restow nvim zsh tmux git
```
