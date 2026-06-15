#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew &>/dev/null; then
  echo "Error: Homebrew is required. Install it from https://brew.sh then re-run this script."
  exit 1
fi

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing stow..."
brew install stow

echo "==> Installing Homebrew packages..."
brew trust chaoscoder/tap 2>/dev/null || true
brew bundle --file="$DOTFILES/Brewfile" || true

echo "==> Stowing dotfiles..."
cd "$DOTFILES"
stow_packages=(nvim zsh tmux git ghostty)
for pkg in "${stow_packages[@]}"; do
  find "$DOTFILES/$pkg" -type f | while read -r src; do
    rel="${src#"$DOTFILES/$pkg/"}"
    target="$HOME/$rel"
    if [ -f "$target" ] && [ ! -L "$target" ]; then
      rm -f "$target"
    fi
  done
done
stow --restow --target="$HOME" "${stow_packages[@]}"

echo "==> Setting up tmux plugin manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Done!"
echo "   Open nvim -> :Lazy will auto-install plugins"
echo "   Open tmux -> prefix + I to install plugins"
echo "   Create ~/.zshrc.local, ~/.gitconfig.local, ~/.config/nvim/init.local.lua for machine-specific overrides"
