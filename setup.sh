#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing stow..."
brew install stow

echo "==> Installing Homebrew packages..."
brew bundle --file="$DOTFILES/Brewfile" || true

echo "==> Stowing dotfiles..."
cd "$DOTFILES"
stow --restow --target="$HOME" nvim zsh tmux git

echo "==> Setting up tmux plugin manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Done!"
echo "   Open nvim -> :Lazy will auto-install plugins"
echo "   Open tmux -> prefix + I to install plugins"
echo "   Create ~/.zshrc.local, ~/.gitconfig.local, ~/.config/nvim/init.local.lua for machine-specific overrides"
